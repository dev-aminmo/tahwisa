import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tahwisa/app/cubits/wish_place_cubit/wish_place_cubit.dart';
import 'package:tahwisa/app/repositories/models/place.dart';
import 'package:tahwisa/app/repositories/models/query_response.dart';
import 'package:tahwisa/app/repositories/place_repository.dart';

import 'bloc.dart';

class WishListBloc extends Bloc<WishListEvent, WishListState> {
  final PlaceRepository? placeRepository;
  final _places$ = BehaviorSubject<List<Place>>();
  Stream<List<Place>> get places => _places$;
  final _places = <Place>[];
  bool isFetching = false;
  int _page = 1;
  int get page => _page;
  final WishPlaceCubit wishPlaceCubit;
  late StreamSubscription _wishPlaceSubscription;

  @override
  Future<Function?> close() {
    _wishPlaceSubscription.cancel();
    _places$.close();
    return super.close().then((value) => value as Function?);
  }

  WishListBloc({required this.placeRepository, required this.wishPlaceCubit})
      : super(WishListInitial()) {
    _monitorWishPlaceCubit();
  }
  @override
  Stream<WishListState> mapEventToState(
    WishListEvent event,
  ) async* {
    if (event is FetchFirstPageWishList) {
      try {
        _page = 1;

        if (event.loading) yield WishListProgress();
        _places.clear();
        final QueryResponse _queryResponse = await (placeRepository!
            .fetchWishListPlaces(1) as Future<QueryResponse>);
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
      final QueryResponse _queryResponse = await (placeRepository!
          .fetchWishListPlaces(_page) as Future<QueryResponse>);
      _places.addAll(_queryResponse.results);
      _places$.add(_places);
      yield WishListSuccess(
        places: _queryResponse.results,
        numPages: event.state.numPages,
      );
    }
  }

  void _monitorWishPlaceCubit() {
    _wishPlaceSubscription = wishPlaceCubit.stream.listen((state) {
      if (state is AddedToWishListSuccess) {
        if (_places.length < 10) {
          add(FetchFirstPageWishList(loading: false));
        }
      }
      if (state is RemovedFromWishListSuccess) {
        int index = this
            ._places
            .indexWhere((place) => (place.id == state.placeId) ? true : false);
        if (index != -1) {
          _places.removeAt(index);
          _places$.add(_places);
        }
      }
    });
  }
}
