import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:habit_tracker/habit.dart';
import 'package:habit_tracker/habitdatabase.dart';

class HabitCreator {
  final dbHelper = HabitDatabase.instance;

  void createHabit(String title, String description, String type, IconData icon) {

    Habit currentHabit = new Habit.createHabit(title, description, type, icon);
    dbHelper.insertHabit(currentHabit);

    Fluttertoast.showToast(msg: "Habit created succesfully"); //TODO implement actual try-catch
  }

  void createDaily(String title, String description, String type, IconData icon, List<String> activedays){
    Habit currentHabit = new Habit.createDaily(title, description, type, icon, activedays);
    dbHelper.insertHabit(currentHabit);

    Fluttertoast.showToast(msg: "Habit created succesfully");
  }

  Future<void> createToDo(String title, String description, String type, IconData icon, DateTime duedate, bool isDone){
    Habit currentHabit = new Habit.createToDo(title, description, type, icon, duedate, isDone);
    dbHelper.insertHabit(currentHabit);

    Fluttertoast.showToast(msg: "Habit created succesfully");

  }

  Future<bool> deleteHabit(Habit habit) async {
    
  int numberofaffectedrows = await dbHelper.delete(habit.id);

    if (numberofaffectedrows > 0) {
      return true;
    }    
    return false;    
  }

  Future<bool> updateHabit(Habit habit) async {

    bool successful = await dbHelper.updateHabit(habit);

    return successful;
  }
}