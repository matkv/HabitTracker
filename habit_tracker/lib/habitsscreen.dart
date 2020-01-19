import 'package:flutter/material.dart';
import 'package:habit_tracker/habit.dart';
import 'package:habit_tracker/habitdatabase.dart';
import 'package:habit_tracker/habitwidget.dart';

class HabitsScreen extends StatefulWidget {
  @override
  _HabitsScreenState createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(10),
          child: HabitWidgetsList(),
        ),
      ),
    );
  }
}

class HabitWidgetsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HabitWidgetListState();
  }
}

class _HabitWidgetListState extends State<HabitWidgetsList> {
  Future<List<Habit>> _future;
  var widgetToShow;
  bool builtfromSwipe = false;

  Future<List<Habit>> getHabitsFromDatabase() async {
    var dbHelper = HabitDatabase.instance;
    var habits;

    await dbHelper.getHabits().then((value) {
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
    return RefreshIndicator(
      child: FutureBuilder(
          //future: getHabitsFromDatabase(),
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<List<Habit>> snapshot) {
            if (builtfromSwipe == false) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  var todowidgets = createHabitWidgets(snapshot);
                  widgetToShow = ListView(
                    scrollDirection: Axis.vertical,
                    children: todowidgets,
                  );
                } else {
                  //show placeholder text if no to-do tasks were created yet
                  widgetToShow = Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'No habits found!',
                      )
                    ],
                  );
                }
              } else {
                //Progress inditcator while todo tasks are loaded
                widgetToShow = Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(),
                    height: 20,
                    width: 20,
                  ),
                );
              }
            }

            return widgetToShow;
          }),
      onRefresh: _refreshList,
    );
  }

  List<Widget> createHabitWidgets(AsyncSnapshot<List<Habit>> snapshot) {
    return snapshot.data.map<Widget>((habit) => HabitWidget(habit)).toList();
  }

  createList(List<Habit> list) {
    return list.map<Widget>((habit) => HabitWidget(habit)).toList();
  }

  Future<void> _refreshList() async {
    await getHabitsFromDatabase().then((value) {
      setState(() {
        builtfromSwipe = true;

        widgetToShow = ListView(
          scrollDirection: Axis.vertical,
          children: createList(value),
        );
      });
    });
  }
}
