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