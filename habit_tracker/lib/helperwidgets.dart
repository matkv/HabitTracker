import 'package:flutter/material.dart';

import 'package:habit_tracker/appcolors.dart';

class SelectableGridViewItem extends StatelessWidget {
  final IconData _icon;
  bool _isSelected;

  SelectableGridViewItem(this._icon, this._isSelected);

  //TODO cleanup

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(
        _icon,
        color: _isSelected ? Colors.white : Colors.red,
      ),
      shape: CircleBorder(),
      fillColor: _isSelected ? Colors.red : AppColors.customColors['lightgrey'],
      onPressed: null,
    );
  }
}