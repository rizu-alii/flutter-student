import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/TimetableQueries.dart';
import 'timetable_event.dart';
import 'timetable_state.dart';
import '../../models/timetable_entry.dart';

class TimetableBloc extends Bloc<TimetableEvent, TimetableState> {
  TimetableBloc() : super(TimetableInitial()) {
    on<LoadTimetableEvent>(_onLoadTimetable);
    on<RefreshTimetableEvent>(_onRefreshTimetable);
  }

  Future<void> _onLoadTimetable(
      LoadTimetableEvent event, Emitter<TimetableState> emit) async {
    emit(TimetableLoading());
    try {
      List<TimetableEntry> data = [];
      if (event.isTeacher) {
        final result = await TimetableQueries.getTeacherTimetable(event.teacherName!);
        data = result.map((map) => TimetableEntry.fromDb(map)).toList();
      } else {
        final result = await TimetableQueries.getStudentTimetable(
          event.batch!, event.program!, event.sectionNumber!,
        );
        data = result.map((map) => TimetableEntry.fromDb(map)).toList();
      }
      emit(TimetableLoaded(data));
    } catch (e) {
      emit(TimetableError(e.toString()));
    }
  }

  Future<void> _onRefreshTimetable(
      RefreshTimetableEvent event, Emitter<TimetableState> emit) async {
    emit(TimetableLoading());
    try {
      List<TimetableEntry> data = [];
      if (event.isTeacher) {
        final result = await TimetableQueries.getTeacherTimetable(event.teacherName!);
        data = result.map((map) => TimetableEntry.fromMap(map)).toList();
      } else {
        final result = await TimetableQueries.getStudentTimetable(
          event.batch!, event.program!, event.sectionNumber!,
        );
        data = result.map((map) => TimetableEntry.fromMap(map)).toList();
      }
      emit(TimetableLoaded(data));
    } catch (e) {
      emit(TimetableError(e.toString()));
    }
  }
}
