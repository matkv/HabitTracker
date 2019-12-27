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
      //don't call this if the widget has been disposed already
      if (this.mounted) {
        setState(() {
          habits = value;
        });
      }
    });

    return habits;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        //future: getHabitsFromDatabase(),
        future: getHabitsFromDatabase(),
        builder: (BuildContext context, AsyncSnapshot<List<Habit>> snapshot) {
          var widgetToShow;

          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              var todowidgets = createToDoWidgets(snapshot);
              widgetToShow = ListView(
                scrollDirection: Axis.vertical,
                children: todowidgets,
              );
            } else {
              //show placeholder text if no to-do tasks were created yet
              widgetToShow = Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'No To-Do tasks found!',
                  )
                ],
              );
            }
          } else {
            //Progress inditcator while todo tasks are loaded
            widgetToShow = Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
                height: 20,
                width: 20,
              ),
            );
          }

          return widgetToShow;
        });
  }

  List<Widget> createToDoWidgets(AsyncSnapshot snapshot) {
    return snapshot.data.map<Widget>((habit) => ToDoWidget(habit)).toList();
  }
}
