import 'package:flutter/material.dart';
import 'package:habit_tracker/appcolors.dart';

import 'package:habit_tracker/habitdatabase.dart';
import 'package:habit_tracker/habiticons.dart';
import 'package:habit_tracker/habitcreator.dart';

class AddHabit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddHabitState(HabitCreator());
  }
}

class _AddHabitState extends State<AddHabit> {
  @override
  void initState() {
    super.initState();
  }

  HabitCreator habitCreator;
  _AddHabitState(this.habitCreator);

  final key = new GlobalKey<_AddHabitState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.red),
              backgroundColor: Colors.white,
              title: Text(
                'Create Habit',
                style: TextStyle(color: Colors.black),
              ),
              bottom: TabBar(
                labelColor: Colors.red,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                      text: 'Habit',
                      icon: new Icon(Icons.check_circle_outline)),
                  Tab(text: 'Daily', icon: new Icon(Icons.calendar_today)),
                  Tab(
                      text: 'To Do',
                      icon: new Icon(Icons.assignment_turned_in)),
                ],
              ),
            ),
            body: Flex(direction:Axis.vertical, children: <Widget>[ Expanded(flex: 1,child: TabBarView(
              children: <Widget>[

                NewHabitDialog(habitCreator),
                NewDailyDialog(),
                NewToDoDialog(),
              ],
            ),),],)
          );
        },
      ),
    );
  }
}

//New habit dialog

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
                                child: SelectableGridViewItem(iconData,
                                    _selectedIcons.contains(iconData)),
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
                              Navigator.pop(context);
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

//Selectable gridview

class SelectableGridViewItem extends StatelessWidget {
  final IconData _icon;
  bool _isSelected;

  SelectableGridViewItem(this._icon, this._isSelected);

  //TODO cleanup

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(
        _icon,
        color: _isSelected ? Colors.white : Colors.red,
      ),
      shape: CircleBorder(),
      fillColor: _isSelected ? Colors.red : AppColors.customColors['lightgrey'],
      onPressed: null,
    );
  }
}

//Daily habit dialog

class NewDailyDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewDailyState();
  }
}

class _NewDailyState extends State<NewDailyDialog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[Text('New Daily')],
    );
  }
}

//To Do dialog

class NewToDoDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewToDoState();
  }
}

class _NewToDoState extends State<NewToDoDialog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[Text('New To-Do')],
    );
  }
}
