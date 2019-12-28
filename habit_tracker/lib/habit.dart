import 'package:flutter/cupertino.dart';

class Habit {
  int id;
  String title;
  String description;
  IconData icon;
  DateTime duedate;
  String type;
  List<String> activedays;

  //default constructor for normal habit  (used for temp habits for building layout)
  Habit(this.title, this.description, this.icon);

  //constructor for "habit" habit
  Habit.createHabit(this.title, this.description, this.type, this.icon);

  //constructor for to-do habit
  Habit.createToDo(this.title, this.description, this.type, this.icon, this.duedate);

  //TODO add this for the other types too
  //constructor for to-do habit with id - used when loading from habitdatabase
  Habit.createToDoWithID(this.id, this.title, this.description, this.type, this.icon, this.duedate);

  //constructor for daily habit
  Habit.createDaily(this.title, this.description, this.type, this.icon, this.activedays);

  Map<String, dynamic> toMap() {  //TODO is this still used?
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
