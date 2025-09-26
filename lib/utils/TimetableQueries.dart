import '../utils/DBHelper.dart';

class TimetableQueries {
  /// 🔍 Search teachers by name (autocomplete)
  static Future<List<Map<String, dynamic>>> searchTeachers(String query) async {
    final db = await DBHelper.database; // ✅ use singleton
    return await db.rawQuery('''
  SELECT DISTINCT i.id, i.name
  FROM instructor i
  WHERE i.name LIKE ?
  ORDER BY i.name
''', ['%$query%']);
  }

  /// 👨‍🏫 Get full week timetable of a teacher
  static Future<List<Map<String, dynamic>>> getTeacherTimetable(String teacherName) async {
    final db = await DBHelper.database;
    return await db.rawQuery('''
      SELECT t.startTime, t.endTime,
             d.name AS day,
             c.name AS course, c.code,
             s.batch, s.program, s.sectionNumber,
             r.name AS room
      FROM timetable t
      JOIN day d ON t.dayId = d.id
      JOIN course c ON t.courseId = c.id
      JOIN instructor i ON t.instructorId = i.id
      JOIN room r ON t.roomId = r.id
      JOIN section s ON t.sectionId = s.id
      WHERE i.name = ?
      ORDER BY d.id, t.startTime
    ''', [teacherName]);
  }

  /// 🎓 Get full week timetable of a student (by section info)
  static Future<List<Map<String, dynamic>>> getStudentTimetable(
      String batch, String program, String sectionNumber) async {
    final db = await DBHelper.database;
    return await db.rawQuery('''
      SELECT t.startTime, t.endTime,
             d.name AS day,
             c.name AS course, c.code,
             i.name AS instructor,
             r.name AS room
      FROM timetable t
      JOIN day d ON t.dayId = d.id
      JOIN course c ON t.courseId = c.id
      JOIN instructor i ON t.instructorId = i.id
      JOIN room r ON t.roomId = r.id
      JOIN section s ON t.sectionId = s.id
      WHERE s.batch = ? AND s.program = ? AND s.sectionNumber = ?
      ORDER BY d.id, t.startTime
    ''', [batch, program, sectionNumber]);
  }
}
