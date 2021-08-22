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
  final List<Place> places;
  SearchSuccess({@required this.places});
  @override
  List<Object> get props => [places];
}

class SearchFailure extends SearchState {
  final String error;

  const SearchFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'SearchFailure { error: $error }';
}
