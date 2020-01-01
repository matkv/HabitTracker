import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:habit_tracker/habit.dart';

class DailyWidget extends StatefulWidget {
  Habit habit;

  DailyWidget(this.habit);

  @override
  _DailyWidgetState createState() => _DailyWidgetState(habit);
}

class _DailyWidgetState extends State<DailyWidget> {
  Habit habit;

  _DailyWidgetState(this.habit);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[Text(habit.title)],
            ),
            Row(
              children: <Widget>[CircleAvatar(child: Text(habit.activedays[0] == true ? 'Y' : 'N'),)],
            ),
             
          ],
        ),
      ),
    );
  }
}
