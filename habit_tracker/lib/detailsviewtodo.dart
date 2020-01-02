import 'package:flutter/material.dart';
import 'package:habit_tracker/habitcreator.dart';
import 'package:habit_tracker/popupdetails.dart';
import 'package:intl/intl.dart';

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
                child:    
                 FloatingActionButton(
                    child: Icon(widget.widget.habit.isdone ? Icons.clear : Icons.check),
                    onPressed: () {     
                      setState(() {
                        widget.widget.habit.isdone = !widget.widget.habit.isdone; //mark as done if not done, or not done if done
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
