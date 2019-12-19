import 'package:flutter/material.dart';

import 'package:habit_tracker/habit.dart';
import 'package:habit_tracker/habitdatabase.dart';
import 'package:habit_tracker/todowidget.dart';

class ToDoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ToDoScreenState();
  }
}

//Main view of Todo screen
class _ToDoScreenState extends State<ToDoScreen> {
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(10),
        child: ToDoWidgetList(),
      ),
    );
  }
}

// ListView of the habits loaded from the database

class ToDoWidgetList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ToDoWidgetsListState();
  }
}

class _ToDoWidgetsListState extends State<ToDoWidgetList> {
  //TODO move this to separate class? used in todowidgetshomescreen too
  Future<List<Habit>> getHabitsFromDatabase() async {
    var dbHelper = HabitDatabase.instance;
    var habits;

    await dbHelper.getTodoHabits().then((value) {
      setState(() {
        habits = value;
      });
    });

    return habits;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        //future: getHabitsFromDatabase(),
        future: getHabitsFromDatabase(),
        builder: (BuildContext context, AsyncSnapshot<List<Habit>> snapshot) {
          List<Widget> children;

          if (snapshot.hasData) {
            children = createToDoWidgets(snapshot);
          } else {
            children = <Widget>[
              Center(
                child: SizedBox(
                  child: CircularProgressIndicator(),
                  height: 20,
                  width: 20,
                ),
              ),
            ];
          }

          return ListView(
            scrollDirection: Axis.vertical,
            children: children,
          );
        });
  }

  List<Widget> createToDoWidgets(AsyncSnapshot snapshot) {

    return  snapshot.data.map<Widget>((habit) => ToDoWidget(habit)).toList();


  }
}
