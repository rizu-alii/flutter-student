import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/TimetableQueries.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchTeachersEvent>(_onSearchTeachers);
  }

  Future<void> _onSearchTeachers(
      SearchTeachersEvent event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      final results = await TimetableQueries.searchTeachers(event.query);
      emit(SearchLoaded(results.map((e) => e['name'] as String).toList()));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
