import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/dailyscreen.dart';
import 'package:habit_tracker/habitsscreen.dart';
import 'package:habit_tracker/homescreen.dart';
import 'package:habit_tracker/todoscreen.dart';
import 'package:habit_tracker/addhabit.dart';

void main() => runApp(HabitTracker());

class HabitTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //disable screen rotation
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: App(),
    );
  }
}

class App extends StatefulWidget {
  final ValueNotifier<double> notifier = null;
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
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: BottomNavigationBar(
          onTap: onNavigationItemTapped,
          type: BottomNavigationBarType.fixed, //this fixes shifting
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                title: Text('Home'), icon: Icon(Icons.home)),
            BottomNavigationBarItem(
                title: Text('Habits'), icon: Icon(Icons.check_circle_outline)),
            BottomNavigationBarItem(
                title: Text('Day'), icon: Icon(Icons.calendar_today)),
            BottomNavigationBarItem(
                title: Text('To Do'), icon: Icon(Icons.assignment_turned_in)),
          ],
          currentIndex: selectedIndex,
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddHabit()));
          },
          tooltip: 'Create Habit',
          elevation: 2.0,
          child: Icon(Icons.add_circle)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  pageChanged(int index) {
    setState(() {
      //update index which is used to set the current page in navigation bar
      selectedIndex = index;
    });
  }

  void onNavigationItemTapped(int itemIndex) {
    //change page when navigation item is pressed
    selectedIndex = itemIndex;
    setState(() {
      //animateToPage resulted in weird highlighting of the icons
      pageController.jumpToPage(itemIndex);
    });
  }
}
