import 'package:flutter/material.dart';

import 'package:habit_tracker/appcolors.dart';

class SelectableGridViewItem extends StatelessWidget {
  IconData _icon;
  String _weekday;

  bool _isSelected;

  //Used for selecting icons
  SelectableGridViewItem(this._icon, this._isSelected) {
    _weekday = null;
  }

  //USed for selecting the active weekdays of daily widgets
  SelectableGridViewItem.weekDays(this._weekday, this._isSelected) {
    _icon = null;
  }

  //TODO cleanup

  @override
  Widget build(BuildContext context) {
    if (_icon == null) {
      //create button with text in it
      return RawMaterialButton(
        child: Text(
          _weekday[0],  //Take the starting letter of the weekday
          style: TextStyle(fontWeight: FontWeight.bold ,color: _isSelected ? Colors.white : Colors.red),
        ),
        shape: CircleBorder(),
        fillColor:
            _isSelected ? Colors.red : AppColors.customColors['lightgrey'],
        onPressed: null,
      );
    } else {
      //create button with icon in it
      return RawMaterialButton(
        child: Icon(
          _icon,
          color: _isSelected ? Colors.white : Colors.red,
        ),
        shape: CircleBorder(),
        fillColor:
            _isSelected ? Colors.red : AppColors.customColors['lightgrey'],
        onPressed: null,
      );
    }
  }
}
