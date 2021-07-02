import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import '../model/todo.dart';
import 'package:path_provider/path_provider.dart';

class DbHelper {
  static final DbHelper _dbhelper = DbHelper._internal();
  String tblTodo = 'Todo';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DbHelper._internal();

  factory DbHelper() {
    return _dbhelper;
  }

  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database?> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'todo.db';
    var dbTodos = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbTodos;
  }

  void _createDb(Database db, int newVersion) async {
    String sql = """CREATE TABLE $tblTodo(
      $colId INTEGER PRIMARY KEY,
      $colTitle TEXT,
      $colDescription TEXT,
      $colPriority INTEGER,
      $colDate TEXT)
    """;

    await db.execute(sql);
  }

  Future<int> insertTodo(Todo todo) async {
    Database? db = await this.db;
    var result = await db!.insert(tblTodo, todo.toMap());
    return result;
  }

  Future<List> getTodos() async {
    Database? db = await this.db;
    var result =
        await db!.rawQuery("SELECT * FROM $tblTodo ORDER BY $colPriority ASC");
    return result;
  }

  Future<int?> getCount() async {
    Database? db = await this.db;
    var result = Sqflite.firstIntValue(
        await db!.rawQuery("select count (*) from $tblTodo"));
    return result;
  }

  Future<int?> updateTodo(Todo todo) async {
    var db = await this.db;
    var result = await db!.update(tblTodo, todo.toMap(),
        where: "$colId = ?", whereArgs: [todo.id]);
    return result;
  }

  Future<int> deleteTodo(int id) async {
    var db = await this.db;
    return await db!.rawDelete('delete from $tblTodo where $colId = $id');
  }
}
