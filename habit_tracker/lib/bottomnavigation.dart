import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  final Function goToPage;
  BottomNavigation(this.goToPage);

  @override
  State<StatefulWidget> createState() {
    return _BottomNavigationState(goToPage);
  }
}

class _BottomNavigationState extends State<BottomNavigation> {
  final Function goToPage;
  _BottomNavigationState(this.goToPage);

  int _selectedIndex = 0;
  
  void onNavigationItemTapped(int itemIndex) {
    _selectedIndex = itemIndex;
    goToPage(itemIndex);
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: BottomNavigationBar(
        onTap: onNavigationItemTapped,
        type: BottomNavigationBarType.fixed, //this fixes shifting
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(title: Text('Home'), icon: Icon(Icons.home)),
          BottomNavigationBarItem(
              title: Text('Habits'), icon: Icon(Icons.check_circle_outline)),
          BottomNavigationBarItem(
              title: Text('Day'), icon: Icon(Icons.calendar_today)),
          BottomNavigationBarItem(
              title: Text('To Do'), icon: Icon(Icons.assignment_turned_in)),
        ],
        currentIndex: _selectedIndex,
      ),
    );
  }
}
