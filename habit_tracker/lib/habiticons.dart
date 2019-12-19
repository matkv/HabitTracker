import 'package:flutter/material.dart';

class HabitIcons {
  static List<IconData> icons = [
    Icons.favorite,
    Icons.whatshot,
    Icons.ac_unit,
  ];

  static const IconsFromString =  <String, IconData> {
    'favorite' : Icons.favorite,
    'whatshot': Icons.whatshot,
    'ac_unit' : Icons.ac_unit
  };

  static final reversedMap = IconsFromString.map((k,v) => MapEntry(v,k));

  static String getStringFromIcon(IconData icon){

    return reversedMap[icon];
  }
}