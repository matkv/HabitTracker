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

  //used for statistics

  int totalHabits = 0;
  int normalHabitsCount = 0;
  int dailyHabitsCount = 0;
  int todoHabitsCount = 0;
  List<Map<String, dynamic>> habitdata;

  @override
  void initState() {
    setDay(DateTime.now());

    getStatistics();

    super.initState();
  }

  getStatistics() async {
    var database = HabitDatabase.instance;
    setState(() async{
      totalHabits = await database.queryRowCount();
    normalHabitsCount = await database.getHabits().then((value) {
      return value.length;
    });
    dailyHabitsCount = await database.getDailyHabits().then((value) {
      return value.length;
    });
    todoHabitsCount = await database.getTodoHabits().then((value) {
      return value.length;
    });
    });
    
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
                      margin: EdgeInsets.all(10),
                      child: Flex(direction: Axis.vertical, children: <Widget>[Expanded(flex: 1,child:  Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.calendar_today,
                                size: 25,
                                color: Colors.red,
                              ),
                              Text(
                                '${DateFormat('MMMM yyyy').format(currentDay)}',
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                          Divider(),
                          Row(
                            children: <Widget>[
                              Text(
                                'Total habits: ' + totalHabits.toString(),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Normal habits: ' +
                                    normalHabitsCount.toString(),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Daily habits: ' +
                                    dailyHabitsCount.toString(),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'To-Do tasks: ' +
                                    todoHabitsCount.toString(),
                              )
                            ],
                          )
                        ],
                      ),)],)
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

  setDay(DateTime date) {
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
