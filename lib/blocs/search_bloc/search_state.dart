part of 'search_bloc.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchProgress extends SearchState {}

class SearchEmpty extends SearchState {}

class SearchSuccess extends SearchState {
  final String query;
  //int page;
  final int numPages;
  final int numResults;
  final SearchFilter filter;
  SearchSuccess({
    @required this.query,
    //  @required this.page,
    @required this.numPages,
    @required this.numResults,
    @required this.filter,
  });

  /// Whether or not there are more pages to load based off
  /// the current `page` and server-provided `numPages`.
  bool canLoadMore(int page) => page + 1 <= numPages;
}

class SearchFailure extends SearchState {
  final String error;

  SearchFailure({@required this.error});

  @override
  String toString() => 'SearchFailure { error: $error }';
}
