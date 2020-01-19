import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:habit_tracker/dailywidget.dart';
import 'package:habit_tracker/habit.dart';
import 'package:habit_tracker/habitdatabase.dart';
import 'package:habit_tracker/helperfunctions.dart';
import 'package:habit_tracker/popupdetails.dart';

class DailyWidgetsHomeScreen extends StatefulWidget {
  DateTime currentDay;

  DailyWidgetsHomeScreen(this.currentDay);

  @override
  State<StatefulWidget> createState() {
    return _DailyWidgetsHomeScreenState(currentDay);
  }
}

class _DailyWidgetsHomeScreenState extends State<DailyWidgetsHomeScreen> {
  Future<List<Habit>> _future;

  DateTime day;
  _DailyWidgetsHomeScreenState(DateTime currentDay) {
    day = currentDay;
  }

  Future<List<Habit>> getHabitsFromDatabase() async {
    var dbHelper = HabitDatabase.instance;
    var habits;

    await dbHelper.getDailyHabits().then((value) {
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
          var weekday = 0;

          //weekday property of date starts with 1
          //my list of bool starts with monday = 0
          weekday = date.weekday - 1;

          if (snapshot.hasData && snapshot.data.length > 0) {
            List<Habit> filteredList = new List<Habit>();

            snapshot.data.forEach((habit) {
              if (habit.activedays[weekday] == true) {
                filteredList.add(habit);
              }
            });

            if (filteredList.length > 0) {
              var dailypreviews = createDailyPreviews(filteredList);
              widgetToShow = ListView(
                scrollDirection: Axis.horizontal,
                children: dailypreviews,
              );
            } else {
              //show placeholder text if no daily tasks were created yet
              widgetToShow = Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'No Daily tasks found!',
                  )
                ],
              );
            }
          } else {
            //Progress inditcator while daily tasks are loaded
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

  List<Widget> createDailyPreviews(List<Habit> list) {
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
                            flex: 2,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 2,
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    habit.title,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                      style: TextStyle(
                                                          fontSize: 15),
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
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              mainAxisSize: MainAxisSize.max,
                                              children: habit.activedays
                                                  .map<Widget>(
                                                      (day) => CircleAvatar(
                                                            radius: 15,
                                                            backgroundColor: day
                                                                ? Colors.green
                                                                : Colors.red,
                                                          ))
                                                  .toList()),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            mainAxisSize: MainAxisSize.max,
                                            children: WeekDays.days
                                                .map((wd) => Container(
                                                    padding: EdgeInsets.only(
                                                        right: 15, left: 10),
                                                    child: Text(wd[0], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),))
                                                .toList(),
                                          ),
                                        ],
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
              ],
            )))
        .toList();
  }
}
