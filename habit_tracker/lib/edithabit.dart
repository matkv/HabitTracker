import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit_tracker/editdaily.dart';
import 'package:habit_tracker/habit.dart';
import 'package:habit_tracker/habitcreator.dart';
import 'package:habit_tracker/habiticons.dart';
import 'package:habit_tracker/helperwidgets.dart';

class EditHabit extends StatefulWidget {
  Habit habit;
  EditHabit(this.habit);

  @override
  State<StatefulWidget> createState() => _EditHabitState(habit);
}

class _EditHabitState extends State<EditHabit> {
  final _formKey = GlobalKey<FormState>();
  Habit habit;

  String _title;
  String _description;
  IconData _icon;
  int _streakinterval;
  DateTime _lastupdate;

  List<IconData> _selectedIcons = [];

  _EditHabitState(this.habit);

  @override
  void initState() {
    _title = habit.title;
    _description = habit.description;
    _icon = habit.icon;
    _lastupdate = habit.lastupdate;
    _streakinterval = habit.streakinterval;

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
              FormField(
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

                          //TODO these two are not set yet in the edit screen
                          habit.lastupdate = _lastupdate;
                          habit.streakinterval = _streakinterval;

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
