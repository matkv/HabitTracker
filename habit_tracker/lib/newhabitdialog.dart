import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'package:habit_tracker/habitcreator.dart';
import 'package:habit_tracker/habitdatabase.dart';
import 'package:habit_tracker/habiticons.dart';
import 'package:habit_tracker/helperwidgets.dart';

class NewHabitDialog extends StatefulWidget {
  final HabitCreator creator;

  NewHabitDialog(this.creator);

  @override
  State<StatefulWidget> createState() {
    return _NewHabitState(creator);
  }
}

class _NewHabitState extends State<NewHabitDialog> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = HabitDatabase.instance;

  HabitCreator creator;

  _NewHabitState(this.creator);

  String _title;
  String _description;
  String _type = "todo";
  IconData _icon;

  List<IconData> _selectedIcons = [];

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
                  )
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
                      crossAxisCount: 6,
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
                    label: Text('Create Habit'),
                    icon: Icon(Icons.save),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        creator.createNewHabit(
                            _title, _description, _type, _icon);

                        Navigator.pop(
                            context,
                            PageTransition(
                              duration: Duration(milliseconds: 250),
                              type: PageTransitionType.upToDown,
                            ));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}