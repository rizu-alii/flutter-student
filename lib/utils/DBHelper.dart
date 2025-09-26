import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/day.dart';
import '../models/course.dart';
import '../models/instructor.dart';
import '../models/room.dart';
import '../models/section.dart';
import '../models/timetable_entry.dart';

class DBHelper {
  static Database? _db;

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
        await db.execute('''
          CREATE TABLE day(
            id INTEGER PRIMARY KEY,
            name TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE course(
            id INTEGER PRIMARY KEY,
            name TEXT,
            code TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE instructor(
            id INTEGER PRIMARY KEY,
            name TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE room(
            id INTEGER PRIMARY KEY,
            name TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE section(
            id INTEGER PRIMARY KEY,
            batch TEXT,
            program TEXT,
            sectionNumber TEXT
          )
        ''');

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

  /// Insert or replace a Day
  static Future<void> insertDay(Day day) async {
    final db = await database;
    await db.insert('day', day.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> insertCourse(Course course) async {
    final db = await database;
    await db.insert('course', course.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> insertInstructor(Instructor instructor) async {
    final db = await database;
    await db.insert('instructor', instructor.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> insertRoom(Room room) async {
    final db = await database;
    await db.insert('room', room.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> insertSection(Section section) async {
    final db = await database;
    await db.insert('section', section.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Insert or replace a TimetableEntry
  static Future<void> insertTimetableEntry(TimetableEntry entry) async {
    final db = await database;

    // Insert all dependencies first
    await insertDay(entry.day);
    await insertCourse(entry.course);
    await insertInstructor(entry.instructor);
    await insertRoom(entry.room);
    await insertSection(entry.section);

    // Then insert the timetable entry
    await db.insert('timetable', entry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
