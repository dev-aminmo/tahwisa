part of 'search_filter_cubit.dart';

abstract class SearchFilterState extends Equatable {
  const SearchFilterState();
}

class SearchFilterInitial extends SearchFilterState {
  @override
  List<Object> get props => [];
}

class FilterLoadedState extends SearchFilterState {
  FilterLoadedState(this.filter);
  final SearchFilter filter;
  @override
  List<Object> get props => [filter];
}
