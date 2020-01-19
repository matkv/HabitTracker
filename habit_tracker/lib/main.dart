import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/dailyscreen.dart';
import 'package:habit_tracker/habitdatabase.dart';
import 'package:habit_tracker/habitsscreen.dart';
import 'package:habit_tracker/homescreen.dart';
import 'package:habit_tracker/todoscreen.dart';
import 'package:habit_tracker/addhabit.dart';
import 'package:page_transition/page_transition.dart';

void main() => runApp(HabitTracker());

class HabitTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //disable screen rotation
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(

        // navigation bar color
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,));

        /* // status bar color
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark)); */

    return MaterialApp(
      title: 'Habit Tracker',
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
  final dbHelper = HabitDatabase.instance;
  int selectedIndex = 0;
  PageController pageController;

  @override
  void initState() {
    pageController = PageController(
      initialPage: selectedIndex,
      keepPage: true,
    );

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
          HomeScreen(onNavigationItemTapped),
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
//            Navigator.push(
//                context, MaterialPageRoute(builder: (context) => AddHabit()));
            Navigator.push(
                context,
                PageTransition(
                    duration: Duration(milliseconds: 250),
                    type: PageTransitionType.downToUp,
                    child: AddHabit()));
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
    setState(() {
      //change page when navigation item is pressed
      selectedIndex = itemIndex;

      //animateToPage resulted in weird highlighting of the icons
      pageController.jumpToPage(itemIndex);
    });
  }
}
