import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(      
      shape: const CircularNotchedRectangle(),
      child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, //this fixes shifting
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                title: Text('Home'), icon: Icon(Icons.home)),
            BottomNavigationBarItem(
                title: Text('Habits'), icon: Icon(Icons.check_circle_outline)),
            BottomNavigationBarItem(
                title: Text('Day'), icon: Icon(Icons.calendar_today)),
            BottomNavigationBarItem(
                title: Text('To Do'), icon: Icon(Icons.assignment_turned_in)),            
          ]),
    );
  }
}
