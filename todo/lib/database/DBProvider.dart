import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:todo/models/todoModel.dart';

class DBProvider {
  DBProvider._();
  static final db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    return _database = await initDB();
  }

  Future initDB() async =>
      await openDatabase(join(await getDatabasesPath(), 'todo_db.db'),
          onCreate: (db, version) async => await db.execute('''
        CREATE TABLE todo (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT not null,
          date TEXT not null,
          desc TEXT not null,
          isCompleted INTEGER DEFAULT 0
        )
        '''), version: 1);

  Future addToDo(TODO newToDo) async {
    try {
      var db = await database;
      return await db.rawInsert(
          ' INSERT INTO todo (title,date,desc,isCompleted) VALUES (?,?,?,?)',
          newToDo.readyInsert());
    } catch (e) {
      return null;
    }
  }

  Future deleteToDo(int id) async {
    try {
      var db = await database;
      await db.delete('todo', where: 'id = $id');
    } catch (e) {
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> getToDo({int completed}) async {
    try {
      var db = await database;
      return await db.query('todo',
          where: "isCompleted = $completed", orderBy: 'id DESC');
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllToDo() async {
    try {
      var db = await database;
      return (await db.query('todo'))
          .map((value) => Map<String, dynamic>.from(value))
          .toList();
    } catch (e) {
      return Future.error("Can't Sync, please try again");
    }
  }

  Future<int> updateToDo(int id) async {
    try {
      var db = await database;
      return await db.update('todo', {'isCompleted': 1}, where: 'id = $id');
    } catch (e) {
      return 0;
    }
  }

  Future<int> deleteHistory() async {
    try {
      var db = await database;
      return await db.delete('todo', where: 'isCompleted = 1');
    } catch (e) {
      return 0;
    }
  }

  Future<dynamic> countToDo({@required completed}) async {
    var db = await database;
    return Sqflite.firstIntValue(await db
        .rawQuery('SELECT count(*) from todo where isCompleted = $completed'));
  }
}
