import 'package:studentapp/models/room.dart';
import 'package:studentapp/models/section.dart';

import 'course.dart';
import 'day.dart';
import 'instructor.dart';

class TimetableEntry {
  final int id;
  final String startTime;
  final String endTime;

  final Day day;
  final Course course;
  final Instructor instructor;
  final Section section;
  final Room room;

  TimetableEntry({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.day,
    required this.course,
    required this.instructor,
    required this.section,
    required this.room,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTime,
      'endTime': endTime,
      'dayId': day.id,
      'dayName': day.name,
      'courseId': course.id,
      'courseName': course.name,
      'courseCode': course.code,
      'instructorId': instructor.id,
      'instructorName': instructor.name,
      'sectionId': section.id,
      'batch': section.batch,
      'program': section.program,
      'sectionNumber': section.sectionNumber,
      'roomId': room.id,
      'roomName': room.name,
    };
  }

  factory TimetableEntry.fromMap(Map<String, dynamic> map) {
    return TimetableEntry(
      id: map['id'] ?? 0,
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      day: Day.fromMap({
        'id': map['dayId'] ?? 0,
        'name': map['dayName'] ?? '',
      }),
      course: Course.fromMap({
        'id': map['courseId'] ?? 0,
        'name': map['courseName'] ?? '',
        'code': map['courseCode'] ?? '',
      }),
      instructor: Instructor.fromMap({
        'id': map['instructorId'] ?? 0,
        'name': map['instructorName'] ?? '',
      }),
      section: Section.fromMap({
        'id': map['sectionId'] ?? 0,
        'batch': map['batch'] ?? '',
        'program': map['program'] ?? '',
        'sectionNumber': map['sectionNumber'] ?? '',
      }),
      room: Room.fromMap({
        'id': map['roomId'] ?? 0,
        'name': map['roomName'] ?? '',
      }),
    );
  }

  factory TimetableEntry.fromApi(Map<String, dynamic> json) {
    return TimetableEntry(
      id: json['id'] ?? 0,
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      day: Day.fromApi(json['day'] ?? {}),
      course: Course.fromApi(json['course'] ?? {}),
      instructor: Instructor.fromApi(json['instructor'] ?? {}),
      section: Section.fromApi(json['section'] ?? {}),
      room: Room.fromApi(json['room'] ?? {}),
    );
  }

  TimetableEntry.fromDb(Map<String, dynamic> map)
      : id = map['id'] ?? 0,
        startTime = map['startTime'] ?? '',
        endTime = map['endTime'] ?? '',
        day = Day(id: 0, name: map['day'] ?? ''),
        course = Course(id: 0, name: map['course'] ?? '', code: map['code'] ?? ''),
        instructor = Instructor(id: 0, name: map['instructor'] ?? ''),
        section = Section(
            id: 0,
            batch: map['batch'] ?? '',
            program: map['program'] ?? '',
            sectionNumber: map['sectionNumber'] ?? ''),
        room = Room(id: 0, name: map['room'] ?? '');
}
