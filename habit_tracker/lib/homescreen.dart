import 'package:flutter/material.dart';

import 'package:flutter_calendar/flutter_calendar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(10),
              child: Calendar(
                showTodayAction: false,
                showCalendarPickerIcon: false,
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Daily Habits',
                      style: TextStyle(fontSize: 25),
                    ),
                    Icon(
                      Icons.add_circle,
                      color: Colors.red,
                      size: 35,
                    ),
                  ],
                )),
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
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Today\'s Tasks',
                    style: TextStyle(fontSize: 25),
                  ),
                  Icon(
                    Icons.add_circle,
                    color: Colors.red,
                    size: 35,
                  )
                ],
              )
            ),
            Column(
              children: <Widget>[
                Container(
                    height: 120,
                    margin: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: createTodoPreviews(),
                    ))
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: Text(
                'Statistics',
                style: TextStyle(fontSize: 25),
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                height: 200.0,
                child: Card(
                  child: Text('test'),
                )),
          ],
        ),
      ),
    );
  }
}

//TODO this is currently the same as daily habit previews
//Just a spaceholder for now

List<Widget> createTodoPreviews() {
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(
                          Icons.done_all,
                          color: Colors.red,
                          size: 20.0,
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(
                          Icons.done_all,
                          color: Colors.red,
                          size: 20.0,
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
