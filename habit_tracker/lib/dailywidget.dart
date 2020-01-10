import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:habit_tracker/habit.dart';
import 'package:habit_tracker/helperfunctions.dart';
import 'package:habit_tracker/popupdetails.dart';
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
    super.initState();
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
                              ],
                            ),
                          ),
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
                                              right: 15, left: 15),
                                          child: Text(
                                            wd[0],
                                            style:
                                                TextStyle(color: Colors.white),
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
