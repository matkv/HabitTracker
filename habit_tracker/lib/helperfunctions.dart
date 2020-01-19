import 'package:habit_tracker/habit.dart';
import 'package:intl/intl.dart';

class HelperFunctions {
  static int boolToInt(bool value) {
    if (value != null) {
      if (value == true) {
        return 1;
      } else {
        return 0;
      }
    } else {
      return null;
    }
  }

  static bool intToBool(int value) {
    if (value != null) {
      if (value == 1) {
        return true;
      } else {
        return false;
      }
    } else {
      return null;
    }
  }

  static bool isActiveDay(Habit habit) {
    List<String> activedaysStrings = new List<String>();

    for (var i = 0; i < habit.activedays.length; i++) {
      if (habit.activedays[i] == true) {
        activedaysStrings.add(WeekDays.days[i]);
      }
    }

    if (activedaysStrings.length > 0) {
      DateTime today = DateTime.now();
      String day = DateFormat('EEEE').format(today);

      if (activedaysStrings.contains(day)) {
        //get dates without the timestamp
        String datelastupdate = DateFormat.yMd().format(habit.lastupdate);
        String todaysdate = DateFormat.yMd().format(DateTime.now());

        if (datelastupdate == todaysdate) {
          if (habit.streak == 0) {
            return true;
          } else {
            return false;
          }
        }

        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  static bool isSpecificDateActiveDay(DateTime specificDay, Habit habit) {
    List<String> activedaysStrings = new List<String>();

    for (var i = 0; i < habit.activedays.length; i++) {
      if (habit.activedays[i] == true) {
        activedaysStrings.add(WeekDays.days[i]);
      }
    }

    if (activedaysStrings.length > 0) {
      DateTime daytocheck = specificDay;
      String day = DateFormat('EEEE').format(daytocheck);

      if (activedaysStrings.contains(day)) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
}

class WeekDays {
  static List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  static List<bool> getActivedays(List<String> currentdays) {
    List<bool> activeDays = List<bool>();

    int index;

    //fill list
    for (var i = 0; i <= 6; i++) {
      activeDays.add(false);
    }

    //if the day is in currentdays, add its index in days to activedays bool list
    days.forEach((String element) => {
          if (currentdays.contains(element))
            {index = days.indexOf(element), activeDays[index] = true}
        });

    return activeDays;
  }
}

class DateHelper {
  DateTime calculateEndDate(DateTime lastUpdate, int daysInterval) {
    var result = lastUpdate.add(Duration(days: daysInterval));
    return result;
  }

  int calculateRemainingDays(DateTime endDate, int daysInterval) {
    var result = endDate.difference(DateTime.now()).inDays;
    return result;
  }
}
