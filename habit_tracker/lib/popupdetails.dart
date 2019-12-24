import 'package:flutter/material.dart';
import 'package:habit_tracker/habit.dart';
import 'package:intl/intl.dart';

class PopUpDetails extends StatelessWidget {
  const PopUpDetails({Key key, @required this.context, @required this.habit})
      : super(key: key);

  final BuildContext context;
  final Habit habit;

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                          habit.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      
                    ],
                  ),
                ],
              ),
            ),
            Expanded(flex: 1,child: Divider(
              indent: 10,
              endIndent: 10,
              thickness: 1.0,
              color: Colors.red,
            ),),
            Expanded(
              flex: 5,
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
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton(
                  child: Icon(Icons.check),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
