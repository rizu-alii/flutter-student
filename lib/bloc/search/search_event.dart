import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchTeachersEvent extends SearchEvent {
  final String query;

  SearchTeachersEvent(this.query);

  @override
  List<Object?> get props => [query];
}
