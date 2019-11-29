import 'package:flutter/material.dart';
import 'package:habit_tracker/bottomnavigation.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/dailyscreen.dart';
import 'package:habit_tracker/habitsscreen.dart';
import 'package:habit_tracker/homescreen.dart';
import 'package:habit_tracker/todoscreen.dart';

void main() => runApp(HabitTracker());

class HabitTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //disable screen rotation
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      home: App(),
    );
  }
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {
  int selectedIndex = 0;

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          pageChanged(index);
        },
        children: <Widget>[
          HomeScreen(),
          HabitsScreen(),
          DailyScreen(),
          ToDoScreen()
        ],
      ),
      bottomNavigationBar: BottomNavigation(goToPage),
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Create Habit',
          elevation: 2.0,
          child: Icon(Icons.add_circle)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  pageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  //animate a pageview swipe when bottomnavigation button is pressed
  void goToPage(int index) {
    setState(() {
      selectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    });
  }
}
