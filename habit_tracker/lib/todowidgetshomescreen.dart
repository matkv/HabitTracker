import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:habit_tracker/habit.dart';
import 'package:habit_tracker/habitdatabase.dart';
import 'package:habit_tracker/popupdetails.dart';
import 'package:habit_tracker/todowidget.dart';
import 'package:intl/intl.dart';

class ToDoWidgetsHomeScreen extends StatefulWidget {
  DateTime currentDay;

  ToDoWidgetsHomeScreen(this.currentDay);

  @override
  State<StatefulWidget> createState() {
    return _ToDoWidgetsHomeScreenState(currentDay);
  }
}

//https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html

class _ToDoWidgetsHomeScreenState extends State<ToDoWidgetsHomeScreen> {
  Future<List<Habit>> _future;

  DateTime day;

  _ToDoWidgetsHomeScreenState(DateTime currentDay) {
    day = currentDay;
  }

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
    var date = widget.currentDay;

    return FutureBuilder(
        //future: getHabitsFromDatabase(),
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<List<Habit>> snapshot) {
          var widgetToShow;

          var formatter = new DateFormat('yyyy-MM-dd');
          String selectedDate = formatter.format(date);

          if (snapshot.hasData) {
            List<Habit> filteredList = new List<Habit>();

            snapshot.data.forEach((habit) {
              if (formatter.format(habit.duedate) == selectedDate) {
                filteredList.add(habit);
              }
            });

            if (filteredList.length > 0){
              var todopreviews = createToDoPreviews(filteredList);
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

  List<Widget> createToDoPreviews(List<Habit> list) {
    return list
        .map<Widget>((habit) => Card(
                child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 0,
                  child: Container(
                    height: 200,
                    width: 250,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
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
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  habit.icon,
                                  size: 35,
                                  color: Colors.red,
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        habit.title,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                )
              ],
            )))
        .toList();
  }
}
