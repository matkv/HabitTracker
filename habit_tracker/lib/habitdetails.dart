import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/habit.dart';

class HabitDetails extends StatefulWidget {
  Habit habit;

  HabitDetails(this.habit);

  @override
  State<StatefulWidget> createState() {
    return _HabitDetailsState(habit);
  }
}

class _HabitDetailsState extends State<HabitDetails> {
  Habit habit;

  _HabitDetailsState(this.habit);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.red),
        actions: <Widget>[Icon(Icons.edit)],
      ),
      body: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        habit.icon,
                        size: 25,
                      )
                    ],
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(habit.title, style: TextStyle(fontSize: 25))
                    ],
                  ),
                ],
              )
            ],
          ),
          Row(
            children: <Widget>[Text(habit.description)],
          ),
          Row(
            children: <Widget>[

            ],
          ),
        ],
      ),
    );
  }
}
