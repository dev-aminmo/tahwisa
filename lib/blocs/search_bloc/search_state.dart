part of 'search_bloc.dart';

@immutable
abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchProgress extends SearchState {}

class SearchEmpty extends SearchState {}

class SearchSuccess extends SearchState {
  final String query;
  final int page;
  final int numPages;
  final int numResults;
  const SearchSuccess({
    @required this.query,
    @required this.page,
    @required this.numPages,
    @required this.numResults,
  });

  @override
  List<Object> get props => [query, page, numPages, numResults];
}

class SearchFailure extends SearchState {
  final String error;

  const SearchFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'SearchFailure { error: $error }';
}
