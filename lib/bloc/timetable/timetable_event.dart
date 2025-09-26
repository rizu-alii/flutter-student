import 'package:equatable/equatable.dart';

abstract class TimetableEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTimetableEvent extends TimetableEvent {}

class RefreshTimetableEvent extends TimetableEvent {}
