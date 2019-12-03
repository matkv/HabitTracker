import 'package:flutter/cupertino.dart';

class Habit {
  String title;
  String description;
  IconData icon;
  DateTime duedate;

  //default constructor for normal habit
  Habit(this.title, this.description, this.icon);

  //constructor for to-do task
  Habit.toDo(this.title, this.description, this.icon, this.duedate);
}
