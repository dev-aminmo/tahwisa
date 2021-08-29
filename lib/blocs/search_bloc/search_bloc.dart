import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tahwisa/repositories/models/place.dart';
import 'package:tahwisa/repositories/models/query_response.dart';
import 'package:tahwisa/repositories/models/tag.dart';
import 'package:tahwisa/repositories/place_repository.dart';
import 'package:tahwisa/repositories/tag_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final PlaceRepository placeRepository;
  final TagRepository tagRepository;
  final searchQueryCubit;

  final _places$ = BehaviorSubject<List<Place>>();
  Stream<List<Place>> get places => _places$;
  final _places = <Place>[];
  bool isFetching = false;
  int _page = 1;
  int get page => _page;

  //int _page=1;
  @override
  Future<Function> close() {
    _places$.close();
  }

  SearchBloc({
    @required this.placeRepository,
    @required this.searchQueryCubit,
    @required this.tagRepository,
  })  : assert(placeRepository != null),
        super(SearchInitial());

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is FetchTags) {
      final List<Tag> _tags = await tagRepository.getTopTags();
      yield TagsFetched(tags: _tags);
    }
    if (event is SearchFirstPageEvent) {
      final QueryResponse _queryResponse =
          await placeRepository.search(query: event.query);
      _places.addAll(_queryResponse.results);
      //Short hand to avoid duplicates
      /*_places$.add([
        ...{..._places}
      ]);*/
      _places$.add(_places);
      //if (places.length == 0) {
      yield SearchSuccess(
          query: event.query,
          numPages: _queryResponse.numPages,
          numResults: _queryResponse.numResults);
      //  } else {
      //     yield SearchSuccess(places: places);
      //   }
    }
    if (event is SearchPageRequested) {
      _page++;
      print("search bloc page $_page .........................");

      final QueryResponse _queryResponse =
          await placeRepository.search(query: event.state.query, page: _page);

      _places.addAll(_queryResponse.results);

      //Short hand to avoid duplicates
      _places$.add(_places);
      //if (places.length == 0) {
      print("page in success state is $_page");
      yield SearchSuccess(
          query: event.state.query,
          numPages: _queryResponse.numPages,
          numResults: _queryResponse.numResults);
    }
  }
}
