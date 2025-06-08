import 'package:path/path.dart';
import 'package:project/uploaded_course.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    return _database ??= await _initDB('courses.db');
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE courses(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            organization TEXT,
            difficulty TEXT,
            rating REAL
            courseLink TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertCourse(UploadedCourse course) async {
    final db = await database;
    return await db.insert('courses', course.toMap());
  }

  Future<List<UploadedCourse>> getCourses() async {
    final db = await database;
    final maps = await db.query('courses');
    return maps.map((e) => UploadedCourse.fromMap(e)).toList();
  }
}
