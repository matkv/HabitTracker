import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:habit_tracker/dailywidget.dart';
import 'package:habit_tracker/habit.dart';
import 'package:habit_tracker/habitdatabase.dart';

class DailyWidgetsHomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DailyWidgetsHomeScreenState();
  }
}

class _DailyWidgetsHomeScreenState extends State<DailyWidgetsHomeScreen>{

  Future<List<Habit>> _future;

  Future<List<Habit>> getHabitsFromDatabase() async {
    var dbHelper = HabitDatabase.instance;
    var habits;

    await dbHelper.getDailyHabits().then((value) {
      //don't call this if the widget has been disposed already
      if (this.mounted) {
        setState(() {
          habits = value;
        });
      }
    });

    return habits;
  }

  @override
  void initState() {
    _future = getHabitsFromDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        //future: getHabitsFromDatabase(),
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<List<Habit>> snapshot) {
          var widgetToShow;

          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              var dailypreviews = createDailyPreviews(snapshot);
              widgetToShow = ListView(
                scrollDirection: Axis.horizontal,
                children: dailypreviews,
              );
            } else {
              //show placeholder text if no daily tasks were created yet
              widgetToShow = Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'No Daily tasks found!',
                  )
                ],
              );
            }
          } else {
            //Progress inditcator while daily tasks are loaded
            widgetToShow = Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
                height: 20,
                width: 20,
              ),
            );
          }

          return widgetToShow;
        });
  }

  List<Widget> createDailyPreviews(AsyncSnapshot snapshot){
    return snapshot.data.map<Widget>((habit) => DailyWidget(habit)).toList();
  }

}
