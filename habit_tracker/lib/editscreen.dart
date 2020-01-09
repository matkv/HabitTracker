import 'package:flutter/material.dart';
import 'package:habit_tracker/editdaily.dart';
import 'package:habit_tracker/edithabit.dart';
import 'package:habit_tracker/edittodo.dart';
import 'package:habit_tracker/habit.dart';

class EditScreen extends StatefulWidget {
  Habit habit;
  EditScreen(this.habit);
  @override
  _EditScreenState createState() => _EditScreenState(habit);
}

class _EditScreenState extends State<EditScreen> {
  Habit habit;
  _EditScreenState(this.habit);

  @override
  Widget build(BuildContext context) {
    switch (habit.type) {
      case "todo":
        return EditTodo(habit);
        break;
      case "daily":
        return EditDaily(habit);
        break;

      case "habit":
      return EditHabit(habit);
      break;
    }
  }
}

