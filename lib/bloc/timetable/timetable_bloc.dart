import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studentapp/bloc/timetable/timetable_event.dart';
import 'package:studentapp/bloc/timetable/timetable_state.dart';
import '../../models/timetable_entry.dart';
import '../../data/network/ApiService.dart';
import '../../utils/DBHelper.dart';
import '../../utils/TimetableQueries.dart';


class TimetableBloc extends Bloc<TimetableEvent, TimetableState> {
  final bool isTeacher;
  final String? teacherName;
  final String? batch;
  final String? program;
  final String? sectionNumber;

  TimetableBloc({
    this.isTeacher = false,
    this.teacherName,
    this.batch,
    this.program,
    this.sectionNumber,
  }) : super(TimetableInitial()) {
    on<LoadTimetableEvent>(_onLoadTimetable);
    on<RefreshTimetableEvent>(_onRefreshTimetable);
  }

  Future<void> _onLoadTimetable(
      LoadTimetableEvent event, Emitter<TimetableState> emit) async {
    emit(TimetableLoading());

    try {
      // 1️⃣ Load from local DB
      List<Map<String, dynamic>> data = [];
      if (isTeacher && teacherName != null) {
        data = await TimetableQueries.getTeacherTimetable(teacherName!);
      } else if (!isTeacher && batch != null && program != null && sectionNumber != null) {
        data = await TimetableQueries.getStudentTimetable(batch!, program!, sectionNumber!);
      }

      if (data.isNotEmpty) {
        // Convert Map → TimetableEntry
        final timetables = data.map((e) => TimetableEntry.fromMap(e)).toList();
        emit(TimetableLoaded(timetables));
      } else {
        // If local DB empty, fetch from API
        final apiData = await ApiService.fetechApi();
        await ApiService.saveApiDataToDb(apiData);

        List<Map<String, dynamic>> dbData = [];
        if (isTeacher && teacherName != null) {
          dbData = await TimetableQueries.getTeacherTimetable(teacherName!);
        } else if (!isTeacher && batch != null && program != null && sectionNumber != null) {
          dbData = await TimetableQueries.getStudentTimetable(batch!, program!, sectionNumber!);
        }

        final timetables = dbData.map((e) => TimetableEntry.fromMap(e)).toList();
        emit(TimetableLoaded(timetables));
      }
    } catch (e) {
      emit(TimetableError(e.toString()));
    }
  }

  Future<void> _onRefreshTimetable(
      RefreshTimetableEvent event, Emitter<TimetableState> emit) async {
    emit(TimetableLoading());

    try {
      // Force refresh from API
      final apiData = await ApiService.fetechApi();
      await ApiService.saveApiDataToDb(apiData);

      List<Map<String, dynamic>> dbData = [];
      if (isTeacher && teacherName != null) {
        dbData = await TimetableQueries.getTeacherTimetable(teacherName!);
      } else if (!isTeacher && batch != null && program != null && sectionNumber != null) {
        dbData = await TimetableQueries.getStudentTimetable(batch!, program!, sectionNumber!);
      }

      final timetables = dbData.map((e) => TimetableEntry.fromMap(e)).toList();
      emit(TimetableLoaded(timetables));
    } catch (e) {
      emit(TimetableError(e.toString()));
    }
  }
}
