import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('my_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const id = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const date = 'TEXT NOT NULL';
    const content = 'TEXT NOT NULL';
    const status = 'BOOL NOT NULL';

    await db.execute('''
    CREATE TABLE todoList (
      id $id,
      date $date,
      content $content,
      status $status
    )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<int> createTodo(String date, String content) async {
    final db = await instance.database;

    final data = {'date': date, 'content': content, 'status': 0};
    return await db.insert('todoList', data); // return : auto-increment value
  }

  Future<List<Map<String, dynamic>>> readAllTodo() async {
    final db = await instance.database;
    return await db.query('todoList');
  }

  Future<List<Map<String, dynamic>>> readDateTodo(String date) async {
    final db = await instance.database;
    return db.query('todoList', where: 'date = ?', whereArgs: [date]);
  }

  Future<int> updateTodo(
      int id, String date, String content, bool status) async {
    final db = await instance.database;

    final data = {'date': date, 'content': content, 'status': status};
    return await db.update('todoList', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteTodo(int id) async {
    final db = await instance.database;

    return await db.delete('todoList', where: 'id = ?', whereArgs: [id]);
  }
}
