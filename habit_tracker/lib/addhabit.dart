import 'package:flutter/material.dart';

import 'package:habit_tracker/habitcreator.dart';
import 'package:habit_tracker/newhabitdialog.dart';
import 'package:habit_tracker/newtododialog.dart';
import 'package:habit_tracker/newdailydialog.dart';

class AddHabit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddHabitState(HabitCreator());
  }
}

class _AddHabitState extends State<AddHabit> {
  @override
  void initState() {
    super.initState();
  }

  HabitCreator habitCreator;
  _AddHabitState(this.habitCreator);

  final key = new GlobalKey<_AddHabitState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.red),
              backgroundColor: Colors.white,
              title: Text(
                'Create Habit',
                style: TextStyle(color: Colors.black),
              ),
              bottom: TabBar(
                labelColor: Colors.red,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                      text: 'Habit',
                      icon: new Icon(Icons.check_circle_outline)),
                  Tab(text: 'Daily', icon: new Icon(Icons.calendar_today)),
                  Tab(
                      text: 'To Do',
                      icon: new Icon(Icons.assignment_turned_in)),
                ],
              ),
            ),
            body: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: TabBarView(
                    children: <Widget>[
                      NewHabitDialog(habitCreator),
                      NewDailyDialog(habitCreator),
                      NewToDoDialog(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}