import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tahwisa/blocs/search_filter_bloc_state_manager/filter_manager_bloc.dart';
import 'package:tahwisa/cubits/wish_place_cubit/wish_place_cubit.dart';
import 'package:tahwisa/repositories/models/SearchFilter.dart';
import 'package:tahwisa/repositories/models/place.dart';
import 'package:tahwisa/repositories/models/query_response.dart';
import 'package:tahwisa/repositories/models/tag.dart';
import 'package:tahwisa/repositories/place_repository.dart';
import 'package:tahwisa/repositories/tag_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  late final PlaceRepository placeRepository;
  final TagRepository tagRepository;
  late final FilterManagerBloc filterManagerBloc;
  final WishPlaceCubit wishPlaceCubit;
  final _places$ = BehaviorSubject<List<Place>>();
  Stream<List<Place>> get places => _places$;
  final _places = <Place>[];
  bool isFetching = false;
  int _page = 1;
  int get page => _page;
  late StreamSubscription _wishPlaceSubscription;

  SearchBloc({
    required this.placeRepository,
    required this.filterManagerBloc,
    required this.tagRepository,
    required this.wishPlaceCubit,
  }) : super(SearchInitial()) {
    _monitorWishPlaceCubit();
  }

  @override
  Future<dynamic> close() {
    _wishPlaceSubscription.cancel();
    _places$.close();
    filterManagerBloc.close();
    return super.close();
  }

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchFirstPageEvent) {
      _page = 1;
      yield SearchProgress();
      _places.clear();
      final QueryResponse _queryResponse = await (placeRepository.search(
          query: event.query ?? '',
          filter: filterManagerBloc.stateToFilter(),
          tagId: event.tag?.id) as FutureOr<QueryResponse>);
      _places.addAll(_queryResponse.results);
      _places$.add(_places);
      //if (places.length == 0) {
      yield SearchSuccess(
          query: event.query,
          numPages: _queryResponse.numPages,
          numResults: _queryResponse.numResults,
          filter: _queryResponse.filter,
          tag: event.tag);
      //  } else {
      //     yield SearchSuccess(places: places);
      //   }
    }
    if (event is SearchPageRequested) {
      _page++;
      final QueryResponse _queryResponse = await (placeRepository.search(
        query: event.state.query ?? '',
        page: _page,
        filter: (state as SearchSuccess).filter,
        tagId: (state as SearchSuccess).tag?.id,
      ) as FutureOr<QueryResponse>);

      _places.addAll(_queryResponse.results);

      _places$.add(_places);
      //if (places.length == 0) {
      yield SearchSuccess(
        query: event.state.query,
        numPages: _queryResponse.numPages,
        numResults: _queryResponse.numResults,
        filter: _queryResponse.filter,
        tag: event.state.tag,
      );
    }
    if (event is FilterUpdated) {
      if (state is SearchSuccess) {
        var oldFilter = (state as SearchSuccess).filter;

        var newFilter = filterManagerBloc.stateToFilter();
        print("oldFilter $oldFilter");
        print("newFilter $newFilter");
        if (oldFilter != newFilter) {
          add(SearchFirstPageEvent(query: (state as SearchSuccess).query));
        }
      }
    }
  }

  void _monitorWishPlaceCubit() {
    _wishPlaceSubscription = wishPlaceCubit.stream.listen((state) {
      if (state is AddedToWishListSuccess) {
        int index = this
            ._places
            .indexWhere((place) => (place.id == state.placeId) ? true : false);
        if (index != -1) {
          _places[index].wished = true;
          _places$.add(_places);
        }
      }
      if (state is RemovedFromWishListSuccess) {
        int index = this
            ._places
            .indexWhere((place) => (place.id == state.placeId) ? true : false);
        if (index != -1) {
          _places[index].wished = false;
          _places$.add(_places);
        }
      }
    });
  }
}
