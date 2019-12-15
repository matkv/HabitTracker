import 'package:flutter/cupertino.dart';

class Habit {
  int id;
  String title;
  String description;
  IconData icon;
  DateTime duedate;
  String type;

  Habit.createHabit(this.title, this.description, this.type, this.icon);

  //default constructor for normal habit
  Habit(this.title, this.description, this.icon);

  //constructor for to-do task
  Habit.toDo(this.title, this.description, this.icon, this.duedate);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duedate': duedate,
      'type': type
    };
  }
}
