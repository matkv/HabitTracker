import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:habit_tracker/habit.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/habitdatabase.dart';

class HomeScreen extends StatefulWidget {
  final dbHelper = HabitDatabase.instance;
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState(dbHelper);
  }

}

class _HomeScreenState extends State<HomeScreen>{
  final dbHelper;

  _HomeScreenState(this.dbHelper);


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
                    IconButton(
                      icon: Icon(
                        Icons.arrow_forward,
                        color: Colors.red,
                        size: 35,
                      ),
                      onPressed: goToDailyScreen(),
                    ),
                  ],
                )),
            Column(
              children: <Widget>[
                Container(
                    height: 150,
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
                    IconButton(
                      icon: Icon(
                        Icons.arrow_forward,
                        color: Colors.red,
                        size: 35,
                      ),
                      onPressed: goToToDoScreen(),
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
                child: SizedBox(
                    width: 140,
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: 140,
                            margin: EdgeInsets.only(top: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 20.0,
                                ),
                                Text(
                                  'Overview',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            indent: 10.0,
                            endIndent: 10.0,
                            thickness: 1.0,
                            color: Colors.red,
                          ),
                          Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.calendar_today,
                                    size: 35,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    'December 2019',
                                    style: TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Statistics',
                                style: TextStyle(fontSize: 30),
                              )
                            ],
                          )
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  goToToDoScreen() {
    //TODO figure out how to control main pagecontroller from here
  }

  goToDailyScreen() {
    //TODO
  }

  List<Widget> createTodoPreviews() {

    List<Habit> _habitsFromDatabase;

    dbHelper.getTodoHabits().then((value){
      setState(() {
        _habitsFromDatabase = value;  //TODO CONTINUE HERE
      });
    });

    List<Habit> _testTodoTasks = [
      Habit.toDo("Buy milk", "Buy milk from the store", Icons.shopping_cart,
          DateTime.now())
    ];

    if(_habitsFromDatabase == null) {

    return [Center(child: Text('No tasks found'),)];
    }
    return _habitsFromDatabase
        .map((habit) => Card(
              child: SizedBox(
                width: 160,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 140,
                      margin: EdgeInsets.only(top: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Icon(
                            Icons.ac_unit,
                            color: Colors.red,
                            size: 20.0,
                          ),
                          Text(
                            habit.title,
                            style: TextStyle(fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      indent: 10.0,
                      endIndent: 10.0,
                      thickness: 1.0,
                      color: Colors.red,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(10.0),
                          width: 90,
                          child: Text(habit.description),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ))
        .toList();
  }
}

List<Widget> createHabitPreviews() {
  List<Habit> _testHabits = [
    Habit("Workout", "Do your daily workout", Icons.ac_unit),
    Habit("Read", "Continue with your book", Icons.book),
    Habit("Music", "Listen to some music", Icons.music_note)
  ];

  return _testHabits
      .map((habit) => Card(
            child: SizedBox(
              width: 160,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 140,
                    margin: EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(
                          habit.icon,
                          color: Colors.red,
                          size: 20.0,
                        ),
                        Text(
                          habit.title,
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    indent: 10.0,
                    endIndent: 10.0,
                    thickness: 1.0,
                    color: Colors.red,
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(10.0),
                          width: 140,
                          child: Text(
                            habit.description,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new DateCircle.isChecked(true),
                          new DateCircle.isChecked(true),
                          new DateCircle.isChecked(false),
                          new DateCircle.isChecked(false),
                          new DateCircle.isChecked(true),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ))
      .toList();
}

class DateCircle extends StatelessWidget {
  Icon icon;
  Color borderColor;
  Color circleColor;

  DateCircle.isChecked(bool isChecked) {
    if (isChecked) {
      circleColor = Colors.white;
      icon = Icon(
        Icons.done,
        color: Colors.red,
        size: 18,
      );
    } else {
      circleColor = Colors.red;
      icon = Icon(
        Icons.close,
        color: Colors.white,
        size: 18,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: icon,
      width: 25.0,
      height: 25.0,
      decoration: new BoxDecoration(
        border: Border.all(color: Colors.red),
        color: circleColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
