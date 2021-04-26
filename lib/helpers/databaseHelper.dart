import 'dart:io';

import 'package:armada/models/Task.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database _db;

  DatabaseHelper._instance();

  String taskTable = 'task';
  String colId = 'id';
  String colTitle = 'title';
  String colNote = 'note';

  String colType = 'type';
  String colStart = 'start';
  String colEnd = 'end';
  String colColor = 'color';

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Database todo;
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'todo.db';
    if (await databaseExists(path)) {
      todo = await openDatabase(path);
    } else {
      todo = await openDatabase(path, version: 1, onCreate: _onCreateDb);
    }

    return todo;
  }

  Future<bool> databaseExists(String path) =>
      databaseFactory.databaseExists(path);

  void _onCreateDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $taskTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colNote TEXT,  $colType TEXT, $colStart TEXT, $colEnd TEXT, $colColor INTEGER)');
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(taskTable);
    return result;
  }

  Future<List<Task>> getTasksList() async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Task> taskList = [];
    taskMapList.forEach((taskMap) {
      taskList.add(Task.fromMap(taskMap));
    });

    return taskList;
  }

  Future<List<Task>> getTasksListType(String type) async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM $taskTable WHERE $colType = ?', [type]);

    final List<Task> taskList = [];
    result.forEach((taskMap) {
      // print('task' + taskMap['color'].type);
      taskList.add(Task.fromMap(taskMap));
    });

    return taskList;
  }

  Future<int> insertTask(Task task) async {
    Database db = await this.db;
    final int result = await db.insert(taskTable, task.toMap());
    return result;
  }

  Future<int> updateTask(Task task) async {
    Database db = await this.db;
    final int result = await db.update(
      taskTable,
      task.toMap(),
      where: '$colId = ?',
      whereArgs: [task.id],
    );
    return result;
  }

  Future<int> deleteTask(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      taskTable,
      where: '$colId = ?',
      whereArgs: [id],
    );

    return result;
  }
}
