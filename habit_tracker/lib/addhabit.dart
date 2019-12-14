import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:habit_tracker/habitdatabase.dart';
import 'package:habit_tracker/habit.dart';

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

  NewToDoDialog nhDialog;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Builder(builder: (BuildContext context) {
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
                Tab(text: 'Habit', icon: new Icon(Icons.check_circle_outline)),
                Tab(text: 'Daily', icon: new Icon(Icons.calendar_today)),
                Tab(text: 'To Do', icon: new Icon(Icons.assignment_turned_in)),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              NewHabitDialog(habitCreator),
              NewDailyDialog(),
              NewToDoDialog(),
            ],
          ),
        );
      }),
    );
  }
}

class HabitCreator {
  final dbHelper = HabitDatabase.instance;

  void createNewHabit(String title, String description, String type) {
    Habit currentHabit = new Habit.createHabit(title, description, type);

    dbHelper.insertHabit(currentHabit);

    Fluttertoast.showToast(msg: "Habit created succesfully");
  }
}

//New habit dialog

class NewHabitDialog extends StatefulWidget {
  HabitCreator creator;

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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Expanded(
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
                                return 'Please enter some text';
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
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            maxLength: 35,
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
                        'Description',
                        style: TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 2,
                    child: FloatingActionButton(
                      child: Icon(Icons.save),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          creator.createNewHabit(_title, _description, _type);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
