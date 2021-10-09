import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tahwisa/repositories/models/place.dart';
import 'package:tahwisa/repositories/models/query_response.dart';
import 'package:tahwisa/repositories/place_repository.dart';

import 'bloc.dart';

class ExplorePlacesBloc extends Bloc<ExplorePlacesEvent, ExplorePlacesState> {
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

  ExplorePlacesBloc({@required this.placeRepository})
      : super(ExplorePlacesInitial());
  @override
  Stream<ExplorePlacesState> mapEventToState(
    ExplorePlacesEvent event,
  ) async* {
    /*if (event is FetchPlaces) {
      if (event.refresh) page = 1;
      if (page == 1) {
        yield ExplorePlacesProgress();
      }
         try {
      final places = await placeRepository.fetchPlaces(page);
      if (places.length == 0) {
        yield ExplorePlacesEmpty();
      } else {
        page++;
        yield ExplorePlacesSuccess(places: places);
      }
       } catch (error) {
        print("error");
        yield ExplorePlacesFailure(error: error.toString());
      }
    }*/

    if (event is FetchFirstPageExplorePlaces) {
      try {
        _page = 1;
        yield ExplorePlacesProgress();
        _places.clear();
        final QueryResponse _queryResponse =
            await placeRepository.fetchPlaces(1);
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
          await placeRepository.fetchPlaces(_page);
      _places.addAll(_queryResponse.results);
      _places$.add(_places);
      yield ExplorePlacesSuccess(
        places: _queryResponse.results,
        numPages: event.state.numPages,
      );
    }
  }
}
