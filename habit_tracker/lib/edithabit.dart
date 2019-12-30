import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit_tracker/habit.dart';
import 'package:habit_tracker/habitcreator.dart';
import 'package:habit_tracker/habiticons.dart';
import 'package:habit_tracker/helperwidgets.dart';
import 'package:habit_tracker/popupdetails.dart';
import 'package:intl/intl.dart';

class EditHabit extends StatefulWidget {
  Habit habit;
  EditHabit(this.habit);
  @override
  _EditHabitState createState() => _EditHabitState(habit);
}

class _EditHabitState extends State<EditHabit> {
  Habit habit;

  String _title;

  _EditHabitState(this.habit);

  @override
  Widget build(BuildContext context) {
    switch (habit.type) {
      case "todo":
        return EditTodo(habit);
        break;
    }
  }
}

//Layout for editing a todo habit

class EditTodo extends StatefulWidget {
  Habit habit;
  EditTodo(this.habit);
  @override
  _EditTodoState createState() => _EditTodoState(habit);
}

class _EditTodoState extends State<EditTodo> {
  final _formKey = GlobalKey<FormState>();
  Habit habit;

  String _title;
  String _description;
  DateTime _dueDate;
  IconData _icon;

  List<IconData> _selectedIcons = [];

  _EditTodoState(this.habit);

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: habit.duedate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _dueDate)
      setState(() {
        _dueDate = picked;
      });
  }

  @override
  void initState() {
    //set initial values (makes saving possible even if nothing changed)
    _title = habit.title;
    _description = habit.description;
    _dueDate = habit.duedate;
    _icon = habit.icon;
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
              FormField(
                autovalidate: false,
                validator: (value) {
                  if (_dueDate == null) {
                    //TODO can't happen
                    return 'Please select a due date';
                  }
                  return null; //TODO check
                },
                builder: (FormFieldState<bool> state) {
                  return Center(
                      child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Text(DateFormat('dd.MMMM yyyy').format(_dueDate)),
                      // SizedBox(
                      //   height: 20.0,
                      // ),
                      RaisedButton(
                        onPressed: () => _selectDate(context),
                        child: Text('Select date'),
                      ),
                    ],
                  ));
                }, //TODO bool needed?
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
                          habit.duedate = _dueDate;
                          habit.icon = _icon;

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
    ;
  }
}
