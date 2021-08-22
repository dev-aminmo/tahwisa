part of 'search_bloc.dart';

@immutable
abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object> get props => [];
}

class SearchFirstPageEvent extends SearchEvent {
  final String query;

  SearchFirstPageEvent({this.query = ''});
}
