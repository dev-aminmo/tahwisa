part of 'search_bloc.dart';

@immutable
abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object> get props => [];
}

class SearchFirstPageEvent extends SearchEvent {
  final String query;
  final Tag tag;

  const SearchFirstPageEvent({this.query, this.tag});

  @override
  List<Object> get props => [query, tag];

  @override
  String toString() {
    return 'SearchFirstPage { query: $query ,tag:$tag }';
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
