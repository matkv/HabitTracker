import 'package:flutter/material.dart';
import 'package:habit_tracker/bottomnavigation.dart';
import 'package:flutter/services.dart';

void main() => runApp(HabitTracker());

class HabitTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    //disable screen rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);


    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      home: Scaffold(
        bottomNavigationBar: BottomNavigation(),        
        floatingActionButton: FloatingActionButton(
            onPressed: () {}, //TODO
            tooltip: 'Create Habit',
            elevation: 2.0,
            child: Icon(Icons.add_circle)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
