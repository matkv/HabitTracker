import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class HabitDatabase{

  //TODO create function that creates or opens the database (maybe on localpath directory)
  //TODO create function that takes a habit object and inserts it into the database

  //Link https://flutter.dev/docs/cookbook/persistence/sqlite


  //this gets the local path where the database will be stored/created
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  //this will oepn a connection with the database (or create it)
  final Future<Database> database = openDatabase(
    join(getDatabasesPath().toString(), 'habit_database.db'),
    onCreate: (db, version){
      return db.execute("CREATE TABLE habits(id INTEGER PRIMARY KEY, title TEXT, description TEXT");
    },
    version: 1,
  );

}