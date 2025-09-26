import 'day.dart';
import 'course.dart';
import 'instructor.dart';
import 'section.dart';
import 'room.dart';

class TimetableEntry {
  final int? id;
  final String startTime;
  final String endTime;

  final Day day;           // ✅ normalized
  final Course course;     // ✅ normalized
  final Instructor instructor; // ✅ normalized
  final Section section;   // ✅ normalized
  final Room room;         // ✅ normalized

  TimetableEntry({
    this.id,
    required this.startTime,
    required this.endTime,
    required this.day,
    required this.course,
    required this.instructor,
    required this.section,
    required this.room,
  });

  /// Convert JSON from API → Object
  factory TimetableEntry.fromJson(Map<String, dynamic> json) {
    return TimetableEntry(
      id: json['id'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      day: Day.fromApi(json['day']),
      course: Course.fromApi(json['course']),
      instructor: Instructor.fromApi(json['instructor']),
      section: Section.fromApi(json['section']),
      room: Room.fromApi(json['room']),
    );
  }

  /// Convert Object → Map for SQLite (storing FKs)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTime,
      'endTime': endTime,
      'dayId': day.id,
      'courseId': course.id,
      'instructorId': instructor.id,
      'sectionId': section.id,
      'roomId': room.id,
    };
  }

  /// Convert Map from SQLite → Object
  factory TimetableEntry.fromMap(Map<String, dynamic> map) {
    return TimetableEntry(
      id: map['id'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      day: Day(id: map['dayId'], name: map['dayName']), // join required
      course: Course(id: map['courseId'], name: map['courseName'], code: map['courseCode']),
      instructor: Instructor(id: map['instructorId'], name: map['instructorName']),
      section: Section(
        id: map['sectionId'],
        batch: map['batch'],
        program: map['program'],
        sectionNumber: map['sectionNumber'],
      ),
      room: Room(id: map['roomId'], name: map['roomName']),
    );
  }
}
