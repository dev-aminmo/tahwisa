part of 'search_bloc.dart';

@immutable
abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object> get props => [];
}

class SearchFirstPageEvent extends SearchEvent {
  final String query;

  const SearchFirstPageEvent(this.query);

  @override
  List<Object> get props => [query];

  @override
  String toString() {
    return 'SearchStarted { query: $query }';
  }
}

class SearchPageRequested extends SearchEvent {
  final SearchSuccess state;
  const SearchPageRequested(this.state);

  @override
  List<Object> get props => [state];

  @override
  String toString() {
    return 'SearchPageRequested { state : $state }';
  }
}

class SearchCleared extends SearchEvent {}

class FilterUpdated extends SearchEvent {}
