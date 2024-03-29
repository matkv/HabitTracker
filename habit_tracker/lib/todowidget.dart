import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:habit_tracker/habit.dart';
import 'package:habit_tracker/popupdetails.dart';
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

  _ToDoWidgetState(this.habit);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: habit.isdone ? Colors.lightGreen : Colors.white,
      child: Container(
        height: 200,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            await showDialog(
              context: context,
              child: PopUpDetails(
                context: context,
                habit: habit,
              ),
            );
            setState(() {
              //this makes the widget reload after marking it as done/not done
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
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
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
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.date_range,
                            color: Colors.red,
                          ),
                          Text(
                            DateFormat.yMMMMd("en_US").format(habit.duedate),
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
              Expanded(
                flex: 1,
                child: Visibility(
                  visible: habit.isdone ? true : false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Ink(
                          decoration: ShapeDecoration(
                            color: Colors.lightGreen,
                            shape: CircleBorder(),
                          ),
                          child: Icon(
                            Icons.done_outline,
                            color: Colors.white,
                            size: 45,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
