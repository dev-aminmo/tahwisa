import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tahwisa/blocs/search_filter_bloc_state_manager/filter_manager_bloc.dart';
import 'package:tahwisa/repositories/models/SearchFilter.dart';
import 'package:tahwisa/repositories/models/place.dart';
import 'package:tahwisa/repositories/models/query_response.dart';
import 'package:tahwisa/repositories/place_repository.dart';
import 'package:tahwisa/repositories/tag_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final PlaceRepository placeRepository;
  final TagRepository tagRepository;
  final FilterManagerBloc filterManagerBloc;

  final _places$ = BehaviorSubject<List<Place>>();
  Stream<List<Place>> get places => _places$;
  final _places = <Place>[];
  bool isFetching = false;
  int _page = 1;
  int get page => _page;

  SearchBloc({
    @required this.placeRepository,
    @required this.filterManagerBloc,
    @required this.tagRepository,
  })  : assert(placeRepository != null),
        super(SearchInitial());
  @override
  Future<dynamic> close() {
    _places$.close();
    filterManagerBloc.close();
    return super.close();
  }

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchFirstPageEvent) {
      yield SearchProgress();
      _places.clear();
      final QueryResponse _queryResponse = await placeRepository.search(
          query: event.query, filter: filterManagerBloc.stateToFilter());
      _places.addAll(_queryResponse.results);
      _places$.add(_places);
      //if (places.length == 0) {
      yield SearchSuccess(
        query: event.query,
        numPages: _queryResponse.numPages,
        numResults: _queryResponse.numResults,
        filter: _queryResponse.filter,
      );
      //  } else {
      //     yield SearchSuccess(places: places);
      //   }
    }
    if (event is SearchPageRequested) {
      _page++;
      final QueryResponse _queryResponse = await placeRepository.search(
          query: event.state.query,
          page: _page,
          filter: (state as SearchSuccess).filter);

      _places.addAll(_queryResponse.results);

      _places$.add(_places);
      //if (places.length == 0) {
      yield SearchSuccess(
        query: event.state.query,
        numPages: _queryResponse.numPages,
        numResults: _queryResponse.numResults,
        filter: _queryResponse.filter,
      );
    }
    if (event is FilterUpdated) {
      if (state is SearchSuccess) {
        var oldFilter = (state as SearchSuccess).filter;

        var newFilter = filterManagerBloc.stateToFilter();
        if (oldFilter != newFilter) {
          add(SearchFirstPageEvent((state as SearchSuccess).query));
        }
      }
    }
  }
}
