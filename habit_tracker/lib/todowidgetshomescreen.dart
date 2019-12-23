import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:habit_tracker/habit.dart';
import 'package:habit_tracker/habitdatabase.dart';
import 'package:intl/intl.dart';

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

  List<Widget> createToDoPreviews(AsyncSnapshot snapshot) {
    return snapshot.data
        .map<Widget>( //TODO move this to own widget class
          (habit) => Card(
            child: Container(
              margin: EdgeInsets.only(top: 5.0),
              height: 200,
              width: 250,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  bool shouldUpdate = await showDialog(
                    context: context,
                    child: Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                      child: Container(
                        width: 100,
                        height: 300,
                        margin: EdgeInsets.all(5),
                        child: Flex(
                          direction: Axis.vertical,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        habit.title,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      habit.description,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    DateFormat.yMMMMd("en_US").format(habit.duedate),
                                    style: TextStyle(fontSize: 15, ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: FloatingActionButton(
                                    child: Icon(Icons.check),
                                    onPressed: () => Navigator.pop(context, true),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  );

                  setState(() {
                    //TODO react to what should happen once task is marked as done
                    // send update command to database that updates the "done" value (TODO)
                    //shouldUpdate ? reload data somehow
                  });
                },
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: <Widget>[
                          Row(
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
                          Divider(
                            indent: 10.0,
                            endIndent: 10.0,
                            thickness: 1.0,
                            color: Colors.red,
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Container(
                                    margin: EdgeInsets.all(10.0),
                                    child: Text(
                                      habit.description,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  color: Colors.red,
                                ),
                                Text(
                                  DateFormat.yMMMMd("en_US")
                                      .format(habit.duedate),
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .toList();
  }
}
