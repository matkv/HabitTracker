import 'package:flutter/material.dart';

import 'package:habit_tracker/habitcreator.dart';
import 'package:habit_tracker/habitdatabase.dart';
import 'package:habit_tracker/habiticons.dart';
import 'package:habit_tracker/helperfunctions.dart';
import 'package:habit_tracker/helperwidgets.dart';
import 'package:page_transition/page_transition.dart';

class NewDailyDialog extends StatefulWidget {
  final HabitCreator creator;

  NewDailyDialog(this.creator);

  @override
  State<StatefulWidget> createState() {
    return _NewDailyState(creator);
  }
}

class _NewDailyState extends State<NewDailyDialog> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = HabitDatabase.instance;

  HabitCreator creator;

  _NewDailyState(this.creator);

  String _title;
  String _description;
  String _type = "daily";
  IconData _icon;

  List<IconData> _selectedIcons = [];
  List<String> _selectedDays = [];
  String _selectedDay = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: GestureDetector(
        onTap: () {
          //this makes it possible to tap outside the textboxes to hide the keyboard
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Title',
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: 250,
                      child: TextFormField(
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
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: 250,
                      child: TextFormField(
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
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Active Days',
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
              FormField(
                autovalidate: false,
                validator: (value) {
                  if (_selectedDays.length == 0) {
                    //TODO show some kind of warning

                    return 'Please select at least one day';
                  }

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
              Row(
                children: <Widget>[
                  Text(
                    'Icon',
                    style: TextStyle(fontSize: 25),
                  ),
                ],
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
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton.extended(
                      label: Text('Create Daily'),
                      icon: Icon(Icons.save),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();

                          DateTime lastUpdate = DateTime.now();
                          int initialStreak = 0;

                          creator.createDaily(
                              _title,
                              _description,
                              _type,
                              _icon,
                              WeekDays.getActivedays(_selectedDays),
                              lastUpdate,
                              initialStreak);

                          Navigator.pop(
                              context,
                              PageTransition(
                                duration: Duration(milliseconds: 250),
                                type: PageTransitionType.upToDown,
                              ));
                        }
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
