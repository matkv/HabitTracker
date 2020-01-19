import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:habit_tracker/habit.dart';
import 'package:habit_tracker/habitdatabase.dart';
import 'package:habit_tracker/helperfunctions.dart';
import 'package:habit_tracker/popupdetails.dart';
import 'package:intl/intl.dart';
import 'dart:collection';

import 'package:quiver/iterables.dart';

class DailyWidget extends StatefulWidget {
  Habit habit;

  DailyWidget(this.habit);

  @override
  _DailyWidgetState createState() => _DailyWidgetState(habit);
}

class _DailyWidgetState extends State<DailyWidget> {
  Habit habit;

  _DailyWidgetState(this.habit);

  @override
  void initState() {
    

    checkAndResetStreak();

    super.initState();
  }

  void checkAndResetStreak() {
    String datelastupdate = DateFormat.yMd().format(habit.lastupdate);
    String todaysdate = DateFormat.yMd().format(DateTime.now());
    
    if (datelastupdate != todaysdate) {
      if (HelperFunctions.isActiveDay(habit)) {
        //only do this on active days
    
        var dayToCheck = DateTime.now().subtract(Duration(days: 1));
    
        while (HelperFunctions.isSpecificDateActiveDay(
            dayToCheck, habit) == false) {
              dayToCheck = dayToCheck.subtract(Duration(days: 1));
            }
    
            if (habit.lastupdate.isAfter(dayToCheck) == false) {
              //reset streak
              habit.streak = 0;
              habit.lastupdate = DateTime.now();
              
              HabitDatabase.instance.updateHabit(habit);
              initState();
            }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 200,
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
          },
          child: Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Row(
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                  flex: 2,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
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
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Flexible(
                                            child: Text(
                                              'Last Update: ' +
                                                  DateFormat.MMMMd("en_US")
                                                      .format(habit.lastupdate),
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          )
                                        ],
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.whatshot,
                                      size: 70,
                                      color: Colors.deepOrange,
                                    ),
                                    Container(
                                        margin:
                                            EdgeInsets.only(top: 20, left: 7),
                                        child: Text(
                                          habit.streak.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      .map<Widget>((day) => CircleAvatar(
                                            radius: 20,
                                            backgroundColor:
                                                day ? Colors.green : Colors.red,
                                          ))
                                      .toList()),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                children: WeekDays.days
                                    .map((wd) => Container(
                                          padding: EdgeInsets.only(
                                              right: 19, left: 15),
                                          child: Text(
                                            wd[0],
                                            style:
                                                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                        ))
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
    );
  }
}
