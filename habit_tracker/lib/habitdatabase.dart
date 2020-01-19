import 'dart:async';
import 'package:habit_tracker/helperfunctions.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:habit_tracker/habit.dart';
import 'package:habit_tracker/habiticons.dart';

class HabitDatabase {
  static final _databaseName = "habit_database.db";
  static final _databaseVersion = 1;

  static final table = 'habits';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnDescription = 'description';
  static final columnType = 'type';
  static final columnDueDate = 'duedate';
  static final columnIcon = 'icon';
  static final columnIsDone = 'isdone'; //used for to-do habits
  static final columnLastUpdate = 'lastupdate';
  static final columnStreakInterval = 'streakinterval';
  static final columnStreak = 'streak';

  static final weekdays = 'weekdays'; //name for weekdays table
  static final columnMonday = 'monday';
  static final columnTuesday = 'tuesday';
  static final columnWednesday = 'wednesday';
  static final columnThursday = 'thursday';
  static final columnFriday = 'friday';
  static final columnSaturday = 'saturday';
  static final columnSunday = 'sunday';

  // make this a singleton class
  HabitDatabase._constructor();

  static final HabitDatabase instance = HabitDatabase._constructor();

  //single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    //instantiate database if it hasn't been created yet
    _database = await _initDatabase();
    return _database;
  }

  // this opens (or creates if it it doesn't exist) the database

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  //SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $table (
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT NOT NULL,
      $columnType TEXT NOT NULL,
      $columnIcon TEXT NOT NULL,
      $columnDescription TEXT,      
      $columnDueDate STRING,
      $columnIsDone INTEGER,
      $columnLastUpdate STRING,
      $columnStreakInterval INTEGER,
      $columnStreak INTEGER
    )
    ''');

    //create weekdays table for daily habits
    await db.execute('''
    CREATE TABLE $weekdays (
      $columnId INTEGER PRIMARY KEY,
      $columnMonday INTEGER NOT NULL,
      $columnTuesday INTEGER NOT NULL,
      $columnWednesday INTEGER NOT NULL,
      $columnThursday INTEGER NOT NULL,
      $columnFriday INTEGER NOT NULL,
      $columnSaturday INTEGER NOT NULL,
      $columnSunday INTEGER NOT NULL
    )
    ''');
  }

  //Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value
  // The return value is the id of the inserted row

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<int> insertWeekdays(int id, List<bool> activedays) async {
    Database db = await instance.database;

    Map<String, dynamic> weekdaysRow = {
      HabitDatabase.columnId: id,
      HabitDatabase.columnMonday: activedays[0] ? 1 : 0,
      HabitDatabase.columnTuesday: activedays[1] ? 1 : 0,
      HabitDatabase.columnWednesday: activedays[2] ? 1 : 0,
      HabitDatabase.columnThursday: activedays[3] ? 1 : 0,
      HabitDatabase.columnFriday: activedays[4] ? 1 : 0,
      HabitDatabase.columnSaturday: activedays[5] ? 1 : 0,
      HabitDatabase.columnSunday: activedays[6] ? 1 : 0,
    };

    return await db.insert(weekdays, weekdaysRow);
  }

  Future<int> updateWeekdays(int id, List<bool> activedays) async {
    Database db = await instance.database;

    Map<String, dynamic> weekdaysRow = {
      HabitDatabase.columnId: id,
      HabitDatabase.columnMonday: activedays[0] ? 1 : 0,
      HabitDatabase.columnTuesday: activedays[1] ? 1 : 0,
      HabitDatabase.columnWednesday: activedays[2] ? 1 : 0,
      HabitDatabase.columnThursday: activedays[3] ? 1 : 0,
      HabitDatabase.columnFriday: activedays[4] ? 1 : 0,
      HabitDatabase.columnSaturday: activedays[5] ? 1 : 0,
      HabitDatabase.columnSunday: activedays[6] ? 1 : 0,
    };

    return await updateDays(weekdaysRow);
  }

  Future<int> getIdOfNewestDaily() async {
    Database db = await instance.database;

    List<int> list;

    await getDailyHabitIDs().then((value) {
      list = value;
    });

    return list.last;
  }

  //All of the rows are returned as a list of maps, where each map is a key-value
  //list of columns

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  //Get row count in table (using raw query) - amount of habits stored
  Future<int> queryRowCount() async {
    Database db = await instance.database;

    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateDays(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db
        .update(weekdays, row, where: '$columnId = ?', whereArgs: [id]);
  }

//Deletes the row specified by the id. The number of affected rows is returned

  Future<int> delete(int id) async {
    Database db = await instance.database;

    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  //add a habit object to the database
  Future<bool> insertHabit(Habit habit) async {
    try {
      HabitDatabase db = instance;

      Map<String, dynamic> row = {
        HabitDatabase.columnName: habit.title,
        HabitDatabase.columnDescription: habit.description,
        HabitDatabase.columnType: habit.type,
        HabitDatabase.columnIcon: HabitIcons.getStringFromIcon(habit.icon),
        HabitDatabase.columnDueDate:
            (habit.duedate == null) ? null : habit.duedate.toIso8601String(),
        HabitDatabase.columnIsDone: HelperFunctions.boolToInt(habit.isdone),
        HabitDatabase.columnLastUpdate: (habit.lastupdate == null)
            ? null
            : habit.lastupdate.toIso8601String(),
        HabitDatabase.columnStreakInterval: habit.streakinterval,
        HabitDatabase.columnStreak: habit.streak
      };

      db.insert(row);
      return true;
    } on Exception catch (e) {
      var errormessage = e.toString();
      Fluttertoast.showToast(msg: "Error: $errormessage");
      return false;
    }
  }

  Future<bool> updateHabit(Habit habit) async {
    try {
      HabitDatabase db = instance;

      Map<String, dynamic> row = {
        HabitDatabase.columnId: habit.id,
        HabitDatabase.columnName: habit.title,
        HabitDatabase.columnDescription: habit.description,
        HabitDatabase.columnType: habit.type,
        HabitDatabase.columnIcon: HabitIcons.getStringFromIcon(habit.icon),
        HabitDatabase.columnDueDate:
            (habit.duedate == null) ? null : habit.duedate.toIso8601String(),
        HabitDatabase.columnIsDone: HelperFunctions.boolToInt(habit.isdone),
        HabitDatabase.columnLastUpdate: (habit.lastupdate == null)
            ? null
            : habit.lastupdate.toIso8601String(),
        HabitDatabase.columnStreakInterval: habit.streakinterval,
        HabitDatabase.columnStreak: habit.streak,
      };

      db.update(row);
      return true;
    } on Exception catch (e) {
      var errormessage = e.toString();
      Fluttertoast.showToast(msg: "Error: $errormessage");
      return false;
    }
  }

  Future<List<Habit>> getHabits() async {
    Database db = await instance.database;
    List<Habit> listOfHabits = [];

    await db
        .rawQuery(
            "SELECT $columnId, $columnName, $columnDescription, $columnType, $columnIcon, $columnLastUpdate, $columnStreakInterval, $columnStreak FROM habits WHERE $columnType = 'habit'")
        .then((value) {
      List<Map> results = value;

      if (results.length != 0) {
        results.forEach((row) => listOfHabits.add(Habit.createHabitWithID(
            row[columnId],
            row[columnName],
            row[columnDescription],
            row[columnType],
            HabitIcons.IconsFromString[row[columnIcon]],
            DateTime.parse(row[columnLastUpdate]),
            row[columnStreakInterval],
            row[columnStreak])));
      }
    });
    return listOfHabits;
  }

  Future<List<int>> getDailyHabitIDs() async {
    Database db = await instance.database;
    List<int> listOfIds = [];

    await db
        .rawQuery("SELECT $columnId FROM habits WHERE $columnType = 'daily'")
        .then((value) {
      List<Map> results = value;

      if (results.length != 0) {
        results.forEach((row) => listOfIds.add(row[columnId]));
      }
    });

    return listOfIds;
  }

  Future<List<bool>> getWeekdays(int id) async {
    Database db = await instance.database;
    List<bool> currentHabitWeekdays = List<bool>();

    await db
        .rawQuery("SELECT * FROM $weekdays WHERE $columnId = $id")
        .then((value) {
      List<Map> results = value;

      if (results.length != 0) {
        results.forEach((row) => {
              //this should always just be 1 row (check)
              currentHabitWeekdays
                  .add(HelperFunctions.intToBool(row[columnMonday])),
              currentHabitWeekdays
                  .add(HelperFunctions.intToBool(row[columnTuesday])),
              currentHabitWeekdays
                  .add(HelperFunctions.intToBool(row[columnWednesday])),
              currentHabitWeekdays
                  .add(HelperFunctions.intToBool(row[columnThursday])),
              currentHabitWeekdays
                  .add(HelperFunctions.intToBool(row[columnFriday])),
              currentHabitWeekdays
                  .add(HelperFunctions.intToBool(row[columnSaturday])),
              currentHabitWeekdays
                  .add(HelperFunctions.intToBool(row[columnSunday])),
            });
      }
    });

    return currentHabitWeekdays;
  }

  Future<List<Habit>> getDailyHabits() async {
    Database db = await instance.database;
    List<Habit> listOfHabits = [];
    List<bool> weekDays;

    await db
        .rawQuery(
            "SELECT $columnId, $columnName, $columnDescription, $columnType, $columnIcon, $columnLastUpdate, $columnStreak FROM habits WHERE $columnType = 'daily'")
        .then((value) {
      List<Map> results = value;

      if (results.length != 0) {
        results.forEach((row) async => {
              await getWeekdays(row[columnId]).then((value) {
                weekDays = value;
              }),
              listOfHabits.add((Habit.createDailyWithID(
                row[columnId],
                row[columnName],
                row[columnDescription],
                row[columnType],
                HabitIcons.IconsFromString[row[columnIcon]],
                weekDays,
                DateTime.parse(row[columnLastUpdate]),
                row[columnStreak]
              )))
            });
      }
    });

    return listOfHabits;
  }

  Future<List<Habit>> getTodoHabits() async {
    Database db = await instance.database;

    List<Habit> listOfHabits = [];

    await db
        .rawQuery(
            "SELECT $columnId, $columnName, $columnDescription, $columnType, $columnIcon, $columnDueDate, $columnIsDone FROM habits WHERE $columnType = 'todo'")
        .then((value) {
      List<Map> results = value;

      if (results.length != 0) {
        results.forEach((row) => listOfHabits.add(Habit.createToDoWithID(
            row[columnId],
            row[columnName],
            row[columnDescription],
            row[columnType],
            HabitIcons.IconsFromString[row[columnIcon]],
            DateTime.parse(row[columnDueDate]),
            HelperFunctions.intToBool(row[columnIsDone])))); //TEMP
      }
    });

    listOfHabits
        .sort((a, b) => a.duedate.compareTo(b.duedate)); //sort list by duedate

    return listOfHabits;
  }
}
