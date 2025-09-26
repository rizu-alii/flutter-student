import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import '../../models/course.dart';
import '../../models/day.dart';
import '../../models/instructor.dart';
import '../../models/room.dart';
import '../../models/section.dart';
import '../../models/timetable_entry.dart';
import '../../utils/DBHelper.dart';
import 'NetworkApiService.dart';

class ApiService {

  static Future<List<TimetableEntry>> fetechApi() async{
     const String baseUrl = "http://10.0.2.2:8000/api/timetable/all";
   NetworkApiService apiService = NetworkApiService();
   final responseJson = await apiService.getApiResponse(baseUrl);
   print(responseJson);
   List<dynamic> data = responseJson;
   List<TimetableEntry> entries =
   data.map((e) => TimetableEntry.fromApi(e)).toList();

   print("✅ Parsed ${entries.length} timetable entries from API");
     print(entries.toString());
     return entries;
  }

  static Future<void> saveApiDataToDb(List<TimetableEntry> entries) async {
    final db = await DBHelper.database;

    try {
      await db.transaction((txn) async {
        Batch batch = txn.batch();

        // 🔹 First clear old data
        batch.delete("timetable");
        batch.delete("day");
        batch.delete("course");
        batch.delete("instructor");
        batch.delete("section");
        batch.delete("room");

        // 🔹 Insert fresh data from API
        for (var entry in entries) {
          batch.insert(
            "day",
            entry.day.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          batch.insert(
            "course",
            entry.course.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          batch.insert(
            "instructor",
            entry.instructor.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          batch.insert(
            "section",
            entry.section.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          batch.insert(
            "room",
            entry.room.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );

          batch.insert(
            "timetable",
            {
              "id": entry.id,
              "startTime": entry.startTime,
              "endTime": entry.endTime,
              "dayId": entry.day.id,
              "courseId": entry.course.id,
              "instructorId": entry.instructor.id,
              "sectionId": entry.section.id,
              "roomId": entry.room.id,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        // Commit batch inside transaction
        await batch.commit(noResult: true);
      });

      print("✅ Transaction complete: Old data safely replaced with new API data");
    } catch (e) {
      print("❌ Failed to save API data: $e");
    }
  }



}

