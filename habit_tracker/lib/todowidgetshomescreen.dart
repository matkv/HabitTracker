import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:habit_tracker/habit.dart';
import 'package:habit_tracker/habitdatabase.dart';
import 'package:habit_tracker/popupdetails.dart';
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
              var todopreviews = createToDoPreviews(snapshot);
              widgetToShow = ListView(
                scrollDirection: Axis.horizontal,
                children: todopreviews,
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

  List<Widget> createToDoPreviews(AsyncSnapshot snapshot) {
    return snapshot.data
        .map<Widget>(
          //TODO move this to own widget class
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
                    child: PopUpDetails(
                      context: context,
                      habit: habit,
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
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                habit.isdone ? Icons.done : Icons.clear,
                                color: habit.isdone ? Colors.green : Colors.red,
                                size: 35,
                              ),
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
                                ),
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
