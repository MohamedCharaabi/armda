import 'dart:io';

import 'package:armada/models/Project.dart';
import 'package:armada/models/Task.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database _db;

  DatabaseHelper._instance();

//Task schema
  String taskTable = 'task';
  String colId = 'id';
  String colTitle = 'title';
  String colNote = 'note';
  String projectId = 'projectid';
  String colType = 'type';
  String colStart = 'start';
  String colEnd = 'end';
  String colColor = 'color';

  //project schema
  String projectTable = 'project';
  String projColId = 'id';
  String projColTitle = 'title';
  String projColNote = 'note';
  String projColStart = 'start';
  String projColEnd = 'end';
  String projColColor = 'color';

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
    //project
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $projectTable ($projColId INTEGER PRIMARY KEY AUTOINCREMENT, $projColTitle TEXT, $projColNote TEXT,  $projColStart TEXT, $projColEnd TEXT, $projColColor INTEGER)');

    //task
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $taskTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $projectId INTEGER , $colTitle TEXT, $colNote TEXT,  $colType TEXT, $colStart TEXT,$colEnd TEXT, $colColor INTEGER, FOREIGN KEY($projectId) REFERENCES $projectTable($projColId))');
  }

// get Map List
  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(taskTable);
    return result;
  }

  Future<List<Map<String, dynamic>>> getProjectMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(projectTable);
    return result;
  }

//get List of (proj/tasks)
  Future<List<Task>> getTasksList() async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Task> taskList = [];
    taskMapList.forEach((taskMap) {
      taskList.add(Task.fromMap(taskMap));
    });

    return taskList;
  }

  Future<List<Project>> getProjectsList() async {
    final List<Map<String, dynamic>> projectMapList = await getProjectMapList();
    final List<Project> projectList = [];
    projectMapList.forEach((projectMap) {
      projectList.add(Project.fromMap(projectMap));
    });

    return projectList;
  }

//
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

//Insert task/proj
  Future<int> insertTask(Task task) async {
    Database db = await this.db;
    final int result = await db.insert(taskTable, task.toMap());
    return result;
  }

  Future<int> insertProject(Project project) async {
    Database db = await this.db;
    final int result = await db.insert(projectTable, project.toMap());
    return result;
  }

//Update task/proj
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

  Future<int> updateProject(Project project) async {
    Database db = await this.db;
    final int result = await db.update(
      projectTable,
      project.toMap(),
      where: '$projColId = ?',
      whereArgs: [project.id],
    );
    return result;
  }

//Delete task/proj
  Future<int> deleteTask(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      taskTable,
      where: '$colId = ?',
      whereArgs: [id],
    );

    return result;
  }

  Future<int> deleteProject(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      projectTable,
      where: '$projColId = ?',
      whereArgs: [id],
    );

    return result;
  }
}
