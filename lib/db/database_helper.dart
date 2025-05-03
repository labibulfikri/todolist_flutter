import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/todo.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'todo.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT
      )
    ''');
  }

  Future<int> insertTodo(Todo todo) async {
    var dbClient = await db;
    return await dbClient.insert('todos', todo.toMap());
  }

  Future<List<Todo>> getTodos() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query('todos');
    return maps.map((map) => Todo.fromMap(map)).toList();
  }

  Future<int> deleteTodo(int id) async {
    var dbClient = await db;
    return await dbClient.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateTodo(Todo todo) async {
    var dbClient = await db;
    return await dbClient.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }
}
