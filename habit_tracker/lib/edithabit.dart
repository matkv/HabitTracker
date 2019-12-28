import 'package:flutter/material.dart';
import 'package:habit_tracker/habit.dart';
import 'package:habit_tracker/popupdetails.dart';
import 'package:intl/intl.dart';

class EditHabit extends StatefulWidget {
  Habit habit;
  EditHabit(this.habit);
  @override
  _EditHabitState createState() => _EditHabitState(habit);
}

class _EditHabitState extends State<EditHabit> {
  final _formKey = GlobalKey<FormState>();

  Habit habit;

  String _title;

  _EditHabitState(this.habit);

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
                              child: TextFormField(
                                initialValue: habit.title,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a title';
                                  }
                                  return null;
                                },
                                maxLength: 20,
                                decoration: InputDecoration(
                                    hintText: 'Enter the name of the habit'),
                                onSaved: (value) {
                                  setState(() {
                                    _title = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                        widget.habit.description,
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
                      DateFormat.yMMMMd("en_US").format(widget.habit.duedate),
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
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
