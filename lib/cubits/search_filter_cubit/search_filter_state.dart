part of 'search_filter_cubit.dart';

abstract class SearchFilterState extends Equatable {
  final SearchFilter filter = SearchFilter();

  @override
  List<Object> get props => [];
}

class SearchFilterInitial extends SearchFilterState {}

class FilterLoadedState extends SearchFilterState {
  FilterLoadedState(this.filter);
  final SearchFilter filter;
  @override
  List<Object> get props => [filter];
}
