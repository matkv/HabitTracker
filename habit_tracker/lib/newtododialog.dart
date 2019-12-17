import 'package:flutter/material.dart';

import 'package:habit_tracker/habitcreator.dart';
import 'package:habit_tracker/habitdatabase.dart';
import 'package:habit_tracker/habiticons.dart';
import 'package:habit_tracker/helperwidgets.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class NewToDoDialog extends StatefulWidget {
  final HabitCreator creator;

  NewToDoDialog(this.creator);

  @override
  State<StatefulWidget> createState() {
    return _NewToDoState(creator);
  }
}

class _NewToDoState extends State<NewToDoDialog> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = HabitDatabase.instance;

  HabitCreator creator;

  _NewToDoState(this.creator);

  String _title;
  String _description;
  String _type = "todo";
  IconData _icon;

  List<IconData> _selectedIcons = [];

  DateTime _dueDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _dueDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _dueDate)
      setState(() {
        _dueDate = picked;
      });
  }

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
                    'Due Date',
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
              FormField(
                autovalidate: false,
                validator: (value) {
                  if (_selectDate(context) == null) {
                    return 'Please select a due date';
                  }
                  return null; //TODO check
                },
                builder: (FormFieldState<bool> state) {
                  return Center(
                      child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(DateFormat('dd.MMMM yyyy').format(_dueDate)),
                      SizedBox(
                        height: 20.0,
                      ),
                      RaisedButton(
                        onPressed: () => _selectDate(context),
                        child: Text('Select date'),
                      ),
                    ],
                  ));
                }, //TODO bool needed?
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
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton.extended(
                    label: Text('Create To Do'),
                    icon: Icon(Icons.save),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();

                        creator.createToDo(
                            _title, _description, _type, _icon, _dueDate);

                        Navigator.pop(
                          context,
                          PageTransition(
                            duration: Duration(milliseconds: 250),
                            type: PageTransitionType.upToDown,
                          ),
                        );
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
