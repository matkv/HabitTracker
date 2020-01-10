import 'package:flutter/material.dart';
import 'package:habit_tracker/habit.dart';
import 'package:habit_tracker/helperfunctions.dart';
import 'package:habit_tracker/popupdetails.dart';
import 'package:intl/intl.dart';

class HabitWidget extends StatefulWidget {
  Habit habit;

  HabitWidget(this.habit);

  @override
  State<StatefulWidget> createState() {
    return _HabitWidgetState(habit);
  }
}

class _HabitWidgetState extends State<HabitWidget> {
  Habit habit;
  int remainingDays;
  DateTime endDate;

  Color checkmarkColor = Colors.grey;

  _HabitWidgetState(this.habit);

  

  @override
  void initState() {
    var helper = DateHelper();
    endDate = helper.calculateEndDate(habit.lastupdate, habit.streakinterval);
    remainingDays = helper.calculateRemainingDays(endDate, habit.streakinterval);

    //todo if remainingdays is 0 (or smaller than zero?) set streak to zero.
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
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    habit.description,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    "Last update: " + DateFormat.MMMMd("en_US").format(habit.lastupdate),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    "End date: " + DateFormat.MMMMd("en_US").format(endDate),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Divider(),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Streak runs out in $remainingDays days',
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Icon(Icons.whatshot, size: 55),
                        Text(habit.streak.toString())
                      ],
                    )
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
