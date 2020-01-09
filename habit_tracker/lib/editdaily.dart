import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit_tracker/habit.dart';
import 'package:habit_tracker/habitcreator.dart';
import 'package:habit_tracker/habiticons.dart';
import 'package:habit_tracker/helperfunctions.dart';
import 'package:habit_tracker/helperwidgets.dart';

//Layout for editing a daily habit

class EditDaily extends StatefulWidget {
  Habit habit;
  EditDaily(this.habit);

  @override
  _EditDailyState createState() => _EditDailyState(habit);
}

class _EditDailyState extends State<EditDaily> {
  final _formKey = GlobalKey<FormState>();
  Habit habit;

  String _title;
  String _description;
  IconData _icon;

  List<IconData> _selectedIcons = [];
  List<String> _selectedDays = [];
  String _selectedDay = '';

  _EditDailyState(this.habit);

  @override
  void initState() {
    //set initial values (makes saving possible even if nothing changed)
    _title = habit.title;
    _description = habit.description;
    _icon = habit.icon;

    for (var i = 0; i < habit.activedays.length; i++) {
      if (habit.activedays[i] == true) {
        //both lists have always the same length so we can use the same index
        _selectedDays.add(WeekDays.days[i]);
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Container(
          width: 100,
          height: 500,
          margin: EdgeInsets.all(10),
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Expanded(
                flex: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        initialValue: habit.title,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                        maxLength: 20,
                        decoration: InputDecoration(
                            hintText: 'Enter the name of the habit'),
                        onSaved: (value) {
                          setState(() {
                            _title = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        initialValue: habit.description,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        maxLength: 65,
                        decoration: InputDecoration(
                            hintText: 'Enter a description of the habit'),
                        onSaved: (value) {
                          setState(() {
                            _description = value;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: FormField(
                  autovalidate: false,
                  validator: (value) {
                    if (_selectedIcons.length == 0) {
                      //TODO show some kind of warning

                      return 'Please select an icon';
                    }

                    return null; //TODO check
                  },
                  builder: (FormFieldState<bool> state) {
                    //TODO bool needed?
                    return SizedBox(
                      height: 50,
                      child: GridView.count(
                        crossAxisCount: 7,
                        crossAxisSpacing: 10.0,
                        children: HabitIcons.icons.map((iconData) {
                          //select current icon by default
                          if (_selectedIcons.length == 0) {
                            _selectedIcons.add(habit.icon);
                          }

                          return GestureDetector(
                            onTap: () {
                              _selectedIcons.clear();

                              setState(() {
                                _selectedIcons.add(iconData);
                                _icon = iconData;
                              });
                            },
                            child: SelectableGridViewItem(
                                iconData, _selectedIcons.contains(iconData)),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: FormField(
                  autovalidate: false,
                  validator: (value) {
                    /* if (_selectedDays.length == 0) {
                      //TODO show some kind of warning

                      return 'Please select at least one day';
                    } */

                    return null; //TODO check
                  },
                  builder: (FormFieldState<bool> state) {
                    return SizedBox(
                      height: 50,
                      child: GridView.count(
                        crossAxisCount: 7,
                        crossAxisSpacing: 10.0,
                        children: WeekDays.days.map((day) {
                          return GestureDetector(
                            onTap: () {
                              //_selectedDays.clear();

                              setState(() {
                                if (_selectedDays.contains(day)) {
                                  _selectedDays.remove(day);
                                  _selectedDay = day;
                                } else {
                                  _selectedDays.add(day);
                                  _selectedDay = day;
                                }
                              });
                            },
                            child: SelectableGridViewItem.weekDays(
                                day, _selectedDays.contains(day)),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
              Divider(
                indent: 10.0,
                endIndent: 10.0,
                thickness: 1.0,
                color: Colors.red,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Delete Habit'),
                    onPressed: () async {
                      Future<bool> successful =
                          HabitCreator().deleteHabit(habit);
                      if (await successful) {
                        Fluttertoast.showToast(
                            msg: "Habit deleted succesfully");
                      }
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton(
                      child: Icon(Icons.save),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();

                          //update values
                          habit.title = _title;
                          habit.description = _description;
                          habit.icon = _icon;
                          habit.activedays =
                              WeekDays.getActivedays(_selectedDays);

                          Future<bool> successful =
                              HabitCreator().updateHabit(habit);
                          if (await successful) {
                            Fluttertoast.showToast(
                                msg: 'Habit updated succesfully');
                          }
                          Navigator.pop(context, true);
                        }
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
