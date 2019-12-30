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
