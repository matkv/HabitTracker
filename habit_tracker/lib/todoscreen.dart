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
  Future<List<Habit>> _future;
  var widgetToShow;
  bool builtfromSwipe = false;

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
  void initState() {
    _future = getHabitsFromDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: FutureBuilder(
          //future: getHabitsFromDatabase(),
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<List<Habit>> snapshot) {
            if (builtfromSwipe == false) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  //sort tasks by done / not done
                  snapshot.data.sort((a, b) =>
                      a.isdone.toString().compareTo(b.isdone.toString()));

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
            }

            return widgetToShow;
          }),
      onRefresh: _refreshList,
    );
  }

  List<Widget> createToDoWidgets(AsyncSnapshot snapshot) {
    List<Widget> list =
        snapshot.data.map<Widget>((habit) => ToDoWidget(habit)).toList();
    return list;
  }

  createList(List<Habit> list) {
    return list.map<Widget>((habit) => ToDoWidget(habit)).toList();
  }

  Future<void> _refreshList() async {
    await getHabitsFromDatabase().then((value) {
      setState(() {
        builtfromSwipe = true;

        widgetToShow = ListView(
          scrollDirection: Axis.vertical,
          children: createList(value),
        );
      });
    });
  }
}
