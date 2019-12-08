import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:habit_tracker/habitdatabase.dart';
import 'package:habit_tracker/habit.dart';

class AddHabit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddHabitState();
  }
}

class _AddHabitState extends State<AddHabit> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
            NewHabitDialog(),
            NewDailyDialog(),
            NewToDoDialog(),
          ],
        ),
        floatingActionButton: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () {}, //TODO
            child: Icon(Icons.save),
          ),
        ),
      ),
    );
  }
}

//New habit dialog

class NewHabitDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewHabitState();
  }
}

class _NewHabitState extends State<NewHabitDialog> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = HabitDatabase.instance;

  String _title;
  String _description;
  String _type = "todo";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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
                Container(
                  width: 250,
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
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
                Container(
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
                    decoration: InputDecoration(
                        hintText: 'Enter a description of the habit'),
                    onSaved: (value) {
                      setState(() {
                        _description = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      Habit currentHabit =
                          new Habit.createHabit(_title, _description, _type);

                      final dbHelper = HabitDatabase.instance;
                      dbHelper.insertHabit(currentHabit);

                      Fluttertoast.showToast(msg: "Habit created succesfully");
                    }
                  },
                  child: Text('Create'),
                ),
                RaisedButton(
                  onPressed: () async {
                    //THIS WORKS!!!!!!!!!!!!!!
                    dbHelper.queryAllRows().then((value) {
                      var test = value;
                    });

                    dbHelper.getTodoHabits().then((value){
                      var test = value;
                    });

                    setState(() {});
                  },
                ),
              ],
            )
          ],
        ),
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
