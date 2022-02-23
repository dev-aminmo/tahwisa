import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tahwisa/cubits/wish_place_cubit/wish_place_cubit.dart';
import 'package:tahwisa/repositories/models/place.dart';
import 'package:tahwisa/repositories/models/query_response.dart';
import 'package:tahwisa/repositories/place_repository.dart';

import 'bloc.dart';

class ExplorePlacesBloc extends Bloc<ExplorePlacesEvent, ExplorePlacesState> {
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

  ExplorePlacesBloc(
      {required this.placeRepository, required this.wishPlaceCubit})
      : super(ExplorePlacesInitial()) {
    add(FetchFirstPageExplorePlaces());
    _monitorWishPlaceCubit();
  }
  @override
  Stream<ExplorePlacesState> mapEventToState(
    ExplorePlacesEvent event,
  ) async* {
    if (event is FetchFirstPageExplorePlaces) {
      try {
        _page = 1;
        yield ExplorePlacesProgress();
        _places.clear();
        final QueryResponse _queryResponse =
            await (placeRepository!.fetchPlaces(1) as FutureOr<QueryResponse>);
        _places.addAll(_queryResponse.results);
        _places$.add(_places);
        yield ExplorePlacesSuccess(
          places: _queryResponse.results,
          numPages: _queryResponse.numPages,
        );
      } catch (error) {
        yield ExplorePlacesFailure(error: error.toString());
      }
    }
    if (event is FetchExplorePlacesPageRequested) {
      _page++;
      final QueryResponse _queryResponse =
          await (placeRepository!.fetchPlaces(_page) as FutureOr<QueryResponse>);
      _places.addAll(_queryResponse.results);
      _places$.add(_places);
      yield ExplorePlacesSuccess(
        places: _queryResponse.results,
        numPages: event.state.numPages,
      );
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
