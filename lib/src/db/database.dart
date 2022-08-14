import 'dart:io';
import 'package:sqflite/sqflite.dart';

import 'package:sqflite/sqlite_api.dart';
import 'package:path_provider/path_provider.dart';
import '../models/todo_model.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}todo_database.db';
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE todo(id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT, deadline TEXT, importance TEXT, done INTEGER, created TEXT, updated TEXT)');
  }

  Future<List<ToDo>> getToDoList() async {
    Database? db = await database;
    final List<Map<String, dynamic>> toDoMapList = await db!.query('todo', orderBy: 'id');
    final List<ToDo> toDoList = [];
    for (var toDoMap in toDoMapList) {
      toDoList.add(ToDo.fromMap(toDoMap));
    }

    return toDoList;
  }

  Future<ToDo> insertToDo(ToDo todo) async {
    Database? db = await database;
    todo.id = await db!.insert('todo', todo.toMap());

    return todo;
  }

  Future<int> deleteToDo(int? id) async {
    Database? db = await database;
    return await db!.delete(
      'todo',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateToDo(ToDo todo) async {
    final db = await database;

    await db!.update(
      'todo',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }
}
