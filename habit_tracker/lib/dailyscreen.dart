import 'package:flutter/material.dart';
import 'package:habit_tracker/dailywidget.dart';
import 'package:habit_tracker/habit.dart';
import 'package:habit_tracker/habitdatabase.dart';

class DailyScreen extends StatefulWidget {
  @override
  _DailyScreenState createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(10),
        child: DailyWidgetsList(),
      ),
    );
  }
}

class DailyWidgetsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DailyWidgetsListState();
  }
}

class _DailyWidgetsListState extends State<DailyWidgetsList> {
  Future<List<Habit>> _future;
  var widgetToShow;
  bool builtfromSwipe = false;

  Future<List<Habit>> getHabitsFromDatabase() async {
    var dbhelper = HabitDatabase.instance;
    var habits;

    await dbhelper.getDailyHabits().then((value) {
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
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<List<Habit>> snapshot) {
            if (builtfromSwipe == false) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  var todowidgets = createDailyWidgets(snapshot);
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
                        'No daily tasks found!',
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

  List<Widget> createDailyWidgets(AsyncSnapshot snapshot) {
    return snapshot.data.map<Widget>((habit) => DailyWidget(habit)).toList();
  }

  createList(List<Habit> list) {
    return list.map<Widget>((habit) => DailyWidget(habit)).toList();
  }

  Future<void> _refreshList() async {
    await getHabitsFromDatabase().then((value) {
      setState(() {
        builtfromSwipe = true;
        if (value.length > 0) {
          widgetToShow = ListView(
          scrollDirection: Axis.vertical,
          children: createList(value),
        );
        }
        
      });
    });
  }
}
