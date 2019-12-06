import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:habit_tracker/habit.dart';

class HabitDatabase {
  // TODO create function that creates or opens the database (maybe on localpath directory)
  // TODO create function that takes a habit object and inserts it into the database

  // NEW TUTORIAL
  // https://medium.com/@suragch/simple-sqflite-database-example-in-flutter-e56a5aaa3f91

  static final _databaseName = "habit_database.db";
  static final _databaseVersion = 1;

  static final table = 'habits';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnDescription = 'description';

  // TODO change names

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
    version: _databaseVersion,
    onCreate: _onCreate);
  }

  //SQL code to create the database table
  Future _onCreate(Database db, int version) async {

    //TODO continue here
    //https://medium.com/@suragch/simple-sqflite-database-example-in-flutter-e56a5aaa3f91
  }



  //TODO everything below this might not be needed anymore

  Future<Database> database;

  HabitDatabase() {
    this.database = openDatabase(
      join(_localPath.toString(), 'habit_database.db'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE habits(id INTEGER PRIMARY KEY, title TEXT, description TEXT");
      },
      version: 1,
    );
  }

  //Link https://flutter.dev/docs/cookbook/persistence/sqlite

  //this gets the local path where the database will be stored/created
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  //add a habit object to the database

  Future<void> insertHabit(Habit habit) async {
    final Database db = await database;

    await db.insert('habits', habit.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
