import 'package:flutter/widgets.dart';
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
        child: Text('Not yet built!'),
      ),
    );
  }
}
