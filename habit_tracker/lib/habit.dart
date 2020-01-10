import 'package:flutter/cupertino.dart';

class Habit {
  int id;
  String title;
  String description;
  IconData icon;
  DateTime duedate;
  String type;
  List<bool> activedays;
  bool isdone;
  DateTime lastupdate;
  int streakinterval;
  int streak;

  //default constructor for normal habit  (used for temp habits for building layout)
  Habit(this.title, this.description, this.icon);

  //constructor for "habit" habit
  Habit.createHabit(this.title, this.description, this.type, this.icon, this.lastupdate, this.streakinterval, this.streak);

  //constructor for habit with id - used when loading from habitdatabse
  Habit.createHabitWithID(
      this.id, this.title, this.description, this.type, this.icon, this.lastupdate, this.streakinterval, this.streak);

  //constructor for to-do habit
  Habit.createToDo(this.title, this.description, this.type, this.icon,
      this.duedate, this.isdone);

  //constructor for to-do habit with id - used when loading from habitdatabase
  Habit.createToDoWithID(this.id, this.title, this.description, this.type,
      this.icon, this.duedate, this.isdone);

  //constructor for daily habit
  Habit.createDaily(
      this.title, this.description, this.type, this.icon, this.activedays);

  //constructor for daily habit with id - used when loading from habitdatabse

  Habit.createDailyWithID(this.id, this.title, this.description, this.type,
      this.icon, this.activedays);

  Map<String, dynamic> toMap() {
    //TODO is this still used?
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'duedate': duedate,
      'type': type,
      'weekdays': activedays
    };
  }
}
