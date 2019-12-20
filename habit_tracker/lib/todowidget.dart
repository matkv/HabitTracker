import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:habit_tracker/habit.dart';
import 'package:habit_tracker/habitdetails.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class ToDoWidget extends StatefulWidget {
  Habit habit;

  ToDoWidget(this.habit);

  @override
  State<StatefulWidget> createState() {
    return _ToDoWidgetState(habit);
  }
}

class _ToDoWidgetState extends State<ToDoWidget> {
  Habit habit;

  Color checkmarkColor = Colors.grey;

  _ToDoWidgetState(this.habit);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 110,
        child: GestureDetector(behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.push(
                context,
              PageTransition(type: PageTransitionType.downToUp, child: HabitDetails(habit)));
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
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: <Widget>[
                          Text(
                            habit.title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            habit.description,
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            DateFormat.yMMMMd("en_US").format(habit.duedate),
                            style: TextStyle(fontSize: 15),
                          )
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
                    Ink(
                      decoration: ShapeDecoration(
                        color: checkmarkColor,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.check),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            if (checkmarkColor == Colors.green) {
                              checkmarkColor = Colors.grey;
                            } else {
                              checkmarkColor = Colors.green;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
