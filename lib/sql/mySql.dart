import 'package:apptodo2/model/Todo.dart';
import 'package:sqflite/sqflite.dart';

class mySql {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = await getDatabasesPath();
    final String databaseName = 'my_database.db';
    final String databasePath = '$path/$databaseName';

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE todo(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, content TEXT, complete BOOLEAN)');
      },
    );
  }

  Future<int> insertData(data) async {
    final Database db = await database;
    return await db.insert('todo', data);
  }

  Future<int> updateData(int id, Map<String, dynamic> data) async {
    final Database db = await database;
    return await db.update('todo', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteData(int id) async {
    final Database db = await database;
    return await db.delete('todo', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getData() async {
    final Database db = await database;
    var abc = await db.query('todo');
    for (var todoList in abc) {
      print(todoList);
    }
    // print(abc);
    return abc;
  }

  Future<List<Todo>> getAll() async {
    List<Todo> todos = <Todo>[];
    final Database db = await database;
    List<Map<String,dynamic>> abc = await db.query('todo');
    for (var todoList in abc) {
      Todo todo = Todo.fromMap(todoList);
      todos.add(todo);
    }
    print(abc);
    return todos;
  }
  Future<List<Map<String, dynamic>>> getTodos() async {
    final db = await database;
    return await db.query('todo');
  }
}
