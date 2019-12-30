import 'dart:async';
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
      $columnDueDate STRING
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

//Deletes the row specified by the id. The number of affected rows is returned

  Future<int> delete(int id) async {
    Database db = await instance.database;

    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  //add a habit object to the database
  Future<bool> insertHabit(Habit habit) async {
    try {
      HabitDatabase db = instance;

      //TODO WEEKDAYS ARE MISSING

      Map<String, dynamic> row = {
        HabitDatabase.columnName: habit.title,
        HabitDatabase.columnDescription: habit.description,
        HabitDatabase.columnType: habit.type,
        HabitDatabase.columnIcon: HabitIcons.getStringFromIcon(habit.icon),
        HabitDatabase.columnDueDate: habit.duedate.toIso8601String()
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
        HabitDatabase.columnDueDate: habit.duedate.toIso8601String()
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
            "SELECT $columnId, $columnName, $columnDescription, $columnType, $columnIcon FROM habits WHERE $columnType = 'habit'")
        .then((value) {
      List<Map> results = value;

      if (results.length != 0) {
        results.forEach((row) => listOfHabits.add(Habit.createHabitWithID(
            row[columnId],
            row[columnName],
            row[columnDescription],
            row[columnType],
            HabitIcons.IconsFromString[row[columnIcon]])));
      }
    });
    return listOfHabits;
  }

  Future<List<Habit>> getDailyHabits() async {
    Database db = await instance.database;
    List<Habit> listOfHabits = [];

    //TODO WEEKDAYS ARE MISSING HERE

    await db
        .rawQuery(
            "SELECT $columnId, $columnName, $columnDescription, $columnType, $columnIcon FROM habits WHERE $columnType = 'daily'")
        .then((value) {
      List<Map> results = value;

      List<String> tempWeekDays = ['Monday', 'Wednesday', 'Saturday'];

      if (results.length != 0) {
        results.forEach((row) => listOfHabits.add((Habit.createDailyWithID(
            row[columnId],
            row[columnName],
            row[columnDescription],
            row[columnType],
            row[columnIcon],
            tempWeekDays))));
      }
    });

    return listOfHabits;
  }

  Future<List<Habit>> getTodoHabits() async {
    Database db = await instance.database;

    List<Habit> listOfHabits = [];

    await db
        .rawQuery(
            "SELECT $columnId, $columnName, $columnDescription, $columnType, $columnIcon, $columnDueDate FROM habits WHERE $columnType = 'todo'")
        .then((value) {
      List<Map> results = value;

      if (results.length != 0) {
        results.forEach((row) => listOfHabits.add(Habit.createToDoWithID(
            row[columnId],
            row[columnName],
            row[columnDescription],
            row[columnType],
            HabitIcons.IconsFromString[row[columnIcon]],
            DateTime.parse(row[columnDueDate])))); //TEMP
      }
    });

    listOfHabits.sort((a,b) => a.duedate.compareTo(b.duedate)); //sort list by duedate

    return listOfHabits;
  }
}
