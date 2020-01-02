import 'package:flutter/material.dart';
import 'package:habit_tracker/habit.dart';

//Layout for editing a daily habit

class EditDaily extends StatefulWidget {
  Habit habit;
  EditDaily(this.habit);

  @override
  _EditDailyState createState() => _EditDailyState(habit);
}

class _EditDailyState extends State<EditDaily> {
  final _formKey = GlobalKey<FormState>();
  Habit habit;

  String _title;
  String _description;
  IconData _icon;

  List<IconData> _selectedIcons = [];

  _EditDailyState(this.habit);

  @override
  void initState() {
    //set initial values (makes saving possible even if nothing changed)
    _title = habit.title;
    _description = habit.description;
    _icon = habit.icon;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Container(
          width: 100,
          height: 500,
          margin: EdgeInsets.all(10),
          child: Text('Not yet built'),
        ),
      ),
    );
  }
}
