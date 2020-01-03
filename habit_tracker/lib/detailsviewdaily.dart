import 'package:flutter/widgets.dart';
import 'package:habit_tracker/habitcreator.dart';
import 'package:habit_tracker/popupdetails.dart';
import 'package:flutter/material.dart';

class DetailsViewDaily extends StatefulWidget {
  const DetailsViewDaily({
    Key key,
    @required this.widget,
    @required this.setEditMode,
  }) : super(key: key);

  final DetailsView widget;
  final VoidCallback setEditMode;

  @override
  _DetailsViewDailyState createState() => _DetailsViewDailyState();
}

class _DetailsViewDailyState extends State<DetailsViewDaily> {
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
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: widget.widget.habit.activedays
                    .map<Widget>((day) => CircleAvatar(
                          radius: 15,
                          child: Text(
                            day ? 'Y' : 'N',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: day ? Colors.green : Colors.red,
                        ))
                    .toList(),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.center,
                child: FloatingActionButton(
                    child: Icon(Icons.check),
                    onPressed: () {
                      Navigator.pop(context, true);
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
