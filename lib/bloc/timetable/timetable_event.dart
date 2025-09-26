import 'package:equatable/equatable.dart';

abstract class TimetableEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTimetableEvent extends TimetableEvent {
  final bool isTeacher;
  final String? teacherName;
  final String? batch;
  final String? program;
  final String? sectionNumber;

  LoadTimetableEvent({
    required this.isTeacher,
    this.teacherName,
    this.batch,
    this.program,
    this.sectionNumber,
  });

  @override
  List<Object?> get props => [isTeacher, teacherName ?? '', batch ?? '', program ?? '', sectionNumber ?? ''];
}

class RefreshTimetableEvent extends TimetableEvent {
  final bool isTeacher;
  final String? teacherName;
  final String? batch;
  final String? program;
  final String? sectionNumber;

  RefreshTimetableEvent({
    required this.isTeacher,
    this.teacherName,
    this.batch,
    this.program,
    this.sectionNumber,
  });

  @override
  List<Object?> get props => [isTeacher, teacherName ?? '', batch ?? '', program ?? '', sectionNumber ?? ''];
}
