import 'package:flutter/material.dart';

class HabitIcons {
  static List<IconData> icons = [
    Icons.favorite,
    Icons.whatshot,
    Icons.ac_unit,
    Icons.alarm,
    Icons.audiotrack,
    Icons.beach_access,
    Icons.book
  ];

  static const IconsFromString =  <String, IconData> {
    'favorite' : Icons.favorite,
    'whatshot': Icons.whatshot,
    'ac_unit' : Icons.ac_unit,
    'alarm' : Icons.alarm,
    'audiotrack' : Icons.audiotrack,
    'beach_access' : Icons.beach_access,
    'book' : Icons.book
  };

  static final reversedMap = IconsFromString.map((k,v) => MapEntry(v,k));

  static String getStringFromIcon(IconData icon){

    return reversedMap[icon];
  }
}