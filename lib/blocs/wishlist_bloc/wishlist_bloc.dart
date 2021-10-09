import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tahwisa/repositories/models/place.dart';
import 'package:tahwisa/repositories/models/query_response.dart';
import 'package:tahwisa/repositories/place_repository.dart';

import 'bloc.dart';

class WishListBloc extends Bloc<WishListEvent, WishListState> {
  final PlaceRepository placeRepository;
  final _places$ = BehaviorSubject<List<Place>>();
  Stream<List<Place>> get places => _places$;
  final _places = <Place>[];
  bool isFetching = false;
  int _page = 1;
  int get page => _page;
  StreamSubscription _wishPlaceSubscription;

  @override
  Future<Function> close() {
    _wishPlaceSubscription.cancel();
    _places$.close();
    return super.close();
  }

  WishListBloc({@required this.placeRepository})
      : assert(placeRepository != null),
        super(WishListInitial());
  @override
  Stream<WishListState> mapEventToState(
    WishListEvent event,
  ) async* {
    if (event is FetchFirstPageWishList) {
      try {
        _page = 1;
        yield WishListProgress();
        _places.clear();
        final QueryResponse _queryResponse =
            await placeRepository.fetchWishListPlaces(1);
        _places.addAll(_queryResponse.results);
        _places$.add(_places);
        yield WishListSuccess(
          places: _queryResponse.results,
          numPages: _queryResponse.numPages,
        );
      } catch (error) {
        yield WishListFailure(error: error.toString());
      }
    }
    if (event is FetchWishListPageRequested) {
      _page++;
      final QueryResponse _queryResponse =
          await placeRepository.fetchWishListPlaces(_page);
      _places.addAll(_queryResponse.results);
      _places$.add(_places);
      yield WishListSuccess(
        places: _queryResponse.results,
        numPages: event.state.numPages,
      );
    }
  }
}
