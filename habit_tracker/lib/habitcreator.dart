import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:habit_tracker/habit.dart';
import 'package:habit_tracker/habitdatabase.dart';

class HabitCreator {
  final dbHelper = HabitDatabase.instance;

  void createNewHabit(String title, String description, String type, IconData icon) {
    Habit currentHabit = new Habit.createHabit(title, description, type, icon);

    dbHelper.insertHabit(currentHabit);

    Fluttertoast.showToast(msg: "Habit created succesfully");
  }

  void createDaily(String title, String description, String type, IconData icon, List<String> weekdays){
    //TODO
  }

  void createToDo(String title, String description, String type, IconData icon, DateTime duedate){

  }
}