import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'user.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  DatabaseHelper._instance();

  // Get the database instance
  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  // Initialize the database
  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'appDB.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Create the table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tbUsers (
        id INTEGER PRIMARY KEY,
        username TEXT,
        email TEXT
      )
    ''');
  }

  // Insert a new user into the database
  Future<int> insertUser(User user) async {
    Database db = await instance.db;
    return await db.insert('tbUsers', user.toMap());
  }

  // Query all users from the database
  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    Database db = await instance.db;
    return await db.query('tbUsers');
  }

  // Update user information in the database
  Future<int> updateUser(User user) async {
    Database db = await instance.db;
    return await db
        .update('tbUsers', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  // Delete user from the database
  Future<int> deleteUser(int id) async {
    Database db = await instance.db;
    return await db.delete('tbUsers', where: 'id = ?', whereArgs: [id]);
  }

  // ฟังก์ชันในการลบข้อมูลทั้งหมด
  Future<void> deleteAllUsers() async {
    Database db = await instance.db;
    await db.delete('tbUsers'); // ลบข้อมูลทั้งหมดจากตาราง
  }

  // Initialize some default users in the database
  Future<void> initializeUsers() async {
    List<User> usersToAdd = [
      User(username: 'John', email: 'john@example.com'),
      User(username: 'Jane', email: 'jane@example.com'),
      User(username: 'Alice', email: 'alice@example.com'),
      User(username: 'Bob', email: 'bob@example.com'),
    ];

    for (User user in usersToAdd) {
      await insertUser(user);
    }
  }
}
