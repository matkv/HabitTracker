import 'package:flutter/material.dart';
import 'package:habit_tracker/detailsviewdaily.dart';
import 'package:habit_tracker/detailsviewhabit.dart';
import 'package:habit_tracker/detailsviewtodo.dart';
import 'package:habit_tracker/editscreen.dart';
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
                ? EditScreen(widget.habit)
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

      case 'daily':
        return DetailsViewDaily(
          widget: widget,
          setEditMode: setEditMode,
        );
        break;

      case 'habit':
        return DetailsViewHabit(
          widget: widget,
          setEditMode: setEditMode,
        );
        break;

      default:
        return Text('Tried building details view which has not been specified');
    }
  }
}

