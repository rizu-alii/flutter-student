import 'package:equatable/equatable.dart';
import '../../models/timetable_entry.dart';

abstract class TimetableState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TimetableInitial extends TimetableState {}

class TimetableLoading extends TimetableState {}

class TimetableLoaded extends TimetableState {
  final List<TimetableEntry> timetables;

  TimetableLoaded(this.timetables);

  @override
  List<Object?> get props => [timetables];
}

class TimetableError extends TimetableState {
  final String message;

  TimetableError(this.message);

  @override
  List<Object?> get props => [message];
}
