import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:habit_tracker/habit.dart';
import 'package:habit_tracker/habitdatabase.dart';

class ToDoWidgetsHomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ToDoWidgetsHomeScreenState();
  }
}

//https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html

class _ToDoWidgetsHomeScreenState extends State<ToDoWidgetsHomeScreen> {
  Future<List<Habit>> getHabitsFromDatabase() async {
    var dbHelper = HabitDatabase.instance;
    var habits;

    await dbHelper.getTodoHabits().then((value) {
      setState(() {
        habits = value;
      });
    });

//    dbHelper.getTodoHabits().then((value) {
//      setState(() {
//        habits = value;
//      });
//    });

    return habits;
  }

  List<Widget> createToDoPreviews(AsyncSnapshot snapshot) {
    return snapshot.data
        .map<Widget>((habit) => Card(
              child: SizedBox(
                width: 160,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 140,
                      margin: EdgeInsets.only(top: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Icon(
                            habit.icon,
                            color: Colors.red,
                            size: 20.0,
                          ),
                          Text(
                            habit.title,
                            style: TextStyle(fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      indent: 10.0,
                      endIndent: 10.0,
                      thickness: 1.0,
                      color: Colors.red,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.all(10.0),
                            width: 90,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(habit.description),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[Text(habit.duedate.toString())],
                                )
                              ],
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        //future: getHabitsFromDatabase(),
        future: getHabitsFromDatabase(),
        builder: (BuildContext context, AsyncSnapshot<List<Habit>> snapshot) {
          List<Widget> children;

          if (snapshot.hasData) {
            children = createToDoPreviews(snapshot);
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
            scrollDirection: Axis.horizontal,
            children: children,
          );
        });
  }
}
