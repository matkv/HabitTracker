import 'package:flutter/material.dart';
import 'package:habit_tracker/habitdatabase.dart';
import 'package:habit_tracker/helperfunctions.dart';
import 'package:habit_tracker/popupdetails.dart';
import 'package:intl/intl.dart';

class DetailsViewHabit extends StatefulWidget {
  const DetailsViewHabit({
    Key key,
    @required this.widget,
    @required this.setEditMode,
  }) : super(key: key);

  final DetailsView widget;
  final VoidCallback setEditMode;

  @override
  _DetailsViewHabitState createState() => _DetailsViewHabitState();
}

class _DetailsViewHabitState extends State<DetailsViewHabit> {
  int remainingDays;
  DateTime endDate;

  @override
  void initState() {
    var helper = DateHelper();
    endDate = helper.calculateEndDate(
        widget.widget.habit.lastupdate, widget.widget.habit.streakinterval);
    remainingDays = helper.calculateRemainingDays(
        endDate, widget.widget.habit.streakinterval);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Container(
        width: 100,
        height: 300,
        margin: EdgeInsets.all(10),
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Expanded(
              flex: 0,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.widget.habit.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
                        color: Colors.red,
                        onPressed: () {
                          widget.setEditMode();
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 0,
              child: Divider(
                indent: 10,
                endIndent: 10,
                thickness: 1.0,
                color: Colors.red,
              ),
            ),Expanded(
              flex: 5,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          widget.widget.habit.description,
                          style: TextStyle(fontSize: 15),
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            "Last update: " +
                                DateFormat.MMMMd("en_US")
                                    .format(widget.widget.habit.lastupdate),
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            "Streak: " + widget.widget.habit.streak.toString(),
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.center,
                child: FloatingActionButton(
                    child: Icon(Icons.check),
                    onPressed: () {
                      setState(() {
                        widget.widget.habit.lastupdate = DateTime.now();
                        widget.widget.habit.streak++; //increase streak
                        var db = HabitDatabase.instance;
                        db.updateHabit(widget.widget.habit);
                      });

                      Navigator.pop(context, true);
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
