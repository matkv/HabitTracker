import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:habit_tracker/dailywidgetshomescreen.dart';
import 'package:habit_tracker/habit.dart';
import 'package:habit_tracker/habitdatabase.dart';
import 'package:habit_tracker/todowidgetshomescreen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final dbHelper = HabitDatabase.instance;
  void Function(int itemIndex) navigateTo;
  HomeScreen(this.navigateTo);

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState(dbHelper, navigateTo);
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final dbHelper;
  void Function(int itemIndex) navigateTo;

  _HomeScreenState(this.dbHelper, this.navigateTo);

  DateTime _currentDay;
  DateTime get currentDay => _currentDay;

  @override
  void initState() {
    // if (_currentDay == null) {
    //   _currentDay = DateTime.now();
    // }

    setDay(DateTime.now());
    
    super.initState();
  }

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
                onDateSelected: (value) => setDay(value),
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
                      onPressed: () => goToDailyScreen(),
                    ),
                  ],
                )),
            Column(
              children: <Widget>[
                Container(
                    height: 180,
                    margin: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: dailyWidgets)
              ],
            ),
            Container(
                margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Tasks ${DateFormat('dd.MM').format(currentDay)}',
                      style: TextStyle(fontSize: 25),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_forward,
                        color: Colors.red,
                        size: 35,
                      ),
                      onPressed: () => goToToDoScreen(),
                    ),
                  ],
                )),
            Column(
              children: <Widget>[
                Container(
                    height: 180,
                    margin: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: todoWidgets)
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
                                    '${DateFormat('MMMM yyyy').format(currentDay)}',
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

  ToDoWidgetsHomeScreen todoWidgets;
  DailyWidgetsHomeScreen dailyWidgets;

  setDay(DateTime date){
    setState(() {
      _currentDay = date;
      
      todoWidgets = new ToDoWidgetsHomeScreen(currentDay);
      dailyWidgets = new DailyWidgetsHomeScreen(currentDay);
    });
    
  }

  Future goToHabitScreen() async {
    navigateTo(1);
  }

  Future goToDailyScreen() async {
    navigateTo(2);
  }

  Future goToToDoScreen() async {
    navigateTo(3);
  }
}

