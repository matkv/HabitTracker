import 'package:flutter/material.dart';

import 'package:flutter_calendar/flutter_calendar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(10),
              child: Calendar(
                showTodayAction: false,
                showCalendarPickerIcon: false,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Text(
                'Daily Habits',
                style: TextStyle(fontSize: 25),
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                    height: 120,
                    margin: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: createHabitPreviews(),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}

List<Widget> createHabitPreviews() {
  List<List<String>> _testStrings = [
    ['Workout', 'Do your daily workout'],
    ['Reading', 'Continue with your book'],
    ['Practise Guitar', 'Practise playing guitar']
  ];

  return _testStrings
      .map((element) => Card(
            child: SizedBox(
              height: 120,
              width: 160,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 140,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.done_all,
                          color: Colors.red,
                          size: 30.0,
                        ),
                        Text(
                          element[0],
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(5.0),
                        width: 150,
                        child: Text(element[1]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ))
      .toList();
}
