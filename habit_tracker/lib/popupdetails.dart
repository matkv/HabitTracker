import 'package:flutter/material.dart';
import 'package:habit_tracker/edithabit.dart';
import 'package:habit_tracker/habit.dart';
import 'package:habit_tracker/habitcreator.dart';
import 'package:habit_tracker/scaleroute.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

bool isEditMode = false;

class PopUpDetails extends StatefulWidget {
  PopUpDetails({Key key, @required this.context, @required this.habit})
      : super(key: key);

  final BuildContext context;
  final Habit habit;

  @override
  _PopUpDetailsState createState() => _PopUpDetailsState();
}

class _PopUpDetailsState extends State<PopUpDetails> {
  setEditMode() {
    setState(() {
      isEditMode = true;
    });
  }

  @override
  void dispose() {
    isEditMode = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: AnimatedContainer(
            curve: Curves.elasticInOut,
            duration: Duration(seconds: 5),
            child: isEditMode
                ? EditHabit(widget.habit)
                : DetailsView(
                    habit: widget.habit,
                    setEditMode: setEditMode,
                  )));
  }
}

class DetailsView extends StatefulWidget {
  DetailsView({Key key, @required this.habit, @required this.setEditMode})
      : super(key: key);

  final Habit habit;
  final VoidCallback setEditMode;

  @override
  _DetailsViewState createState() => _DetailsViewState(setEditMode, habit);
}

class _DetailsViewState extends State<DetailsView> {
  var setEditMode;
  Habit habit;

  _DetailsViewState(this.setEditMode, this.habit);

  set isEditMode(bool value) {
    isEditMode = value;
  }

  @override
  Widget build(BuildContext context) {
    switch (habit.type) {
      case 'todo':
        return DetailsViewTodo(
          widget: widget,
          setEditMode: setEditMode,
        );
        break;
      default:
        return Text('Tried building details view which has not been specified');
    }
  }
}

class DetailsViewTodo extends StatefulWidget {
  const DetailsViewTodo({
    Key key,
    @required this.widget,
    @required this.setEditMode,
  }) : super(key: key);

  final DetailsView widget;
  final VoidCallback setEditMode;

  @override
  _DetailsViewTodoState createState() => _DetailsViewTodoState();
}

class _DetailsViewTodoState extends State<DetailsViewTodo> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Container(
        width: 100,
        height: 300,
        margin: EdgeInsets.all(10),
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Expanded(
              flex: 0,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.widget.habit.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
                        color: Colors.red,
                        onPressed: () {
                          widget.setEditMode();
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 0,
              child: Divider(
                indent: 10,
                endIndent: 10,
                thickness: 1.0,
                color: Colors.red,
              ),
            ),
            Expanded(
              flex: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      widget.widget.habit.description,
                      style: TextStyle(fontSize: 15),
                    ),
                  )
                ],
              ),
            ),
            Divider(),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.date_range,
                    color: Colors.red,
                  ),
                  Text(
                    DateFormat.yMMMMd("en_US").format(widget.widget.habit.duedate),
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton(
                    child: Icon(Icons.check),
                    onPressed: () {     
                      setState(() {
                        widget.widget.habit.isdone = true;
                        HabitCreator().updateHabit(widget.widget.habit);
                      });                 
                      Navigator.pop(context, true);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
