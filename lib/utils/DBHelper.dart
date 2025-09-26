import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DBHelper {

  static Database? _db;

  /// Singleton getter
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), "student.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
// Day table
        await db.execute('''
        CREATE TABLE day(
          id INTEGER PRIMARY KEY,
          name TEXT
        )
      ''');

// Course table
        await db.execute('''
        CREATE TABLE course(
          id INTEGER PRIMARY KEY,
          name TEXT,
          code TEXT
        )
      ''');

// Instructor table
        await db.execute('''
        CREATE TABLE instructor(
          id INTEGER PRIMARY KEY,
          name TEXT
        )
      ''');

// Room table
        await db.execute('''
        CREATE TABLE room(
          id INTEGER PRIMARY KEY,
          name TEXT
        )
      ''');

// Section table
        await db.execute('''
        CREATE TABLE section(
          id INTEGER PRIMARY KEY,
          batch TEXT,
          program TEXT,
          sectionNumber TEXT
        )
      ''');

// Timetable table → links all foreign keys
        await db.execute('''
        CREATE TABLE timetable(
          id INTEGER PRIMARY KEY,
          startTime TEXT,
          endTime TEXT,
          dayId INTEGER,
          courseId INTEGER,
          instructorId INTEGER,
          sectionId INTEGER,
          roomId INTEGER,
          FOREIGN KEY(dayId) REFERENCES day(id),
          FOREIGN KEY(courseId) REFERENCES course(id),
          FOREIGN KEY(instructorId) REFERENCES instructor(id),
          FOREIGN KEY(sectionId) REFERENCES section(id),
          FOREIGN KEY(roomId) REFERENCES room(id)
        )
      ''');
      },
    );
  }


}