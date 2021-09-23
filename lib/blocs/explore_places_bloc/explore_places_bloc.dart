import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'bloc.dart';

class ExplorePlacesBloc extends Bloc<ExplorePlacesEvent, ExplorePlacesState> {
  final placeRepository;
  int page = 1;
  bool isFetching = false;
  ExplorePlacesBloc({@required this.placeRepository})
      : assert(placeRepository != null),
        super(ExplorePlacesInitial());
  @override
  Stream<ExplorePlacesState> mapEventToState(
    ExplorePlacesEvent event,
  ) async* {
    if (event is PlaceFetched) {
      if (event.refresh) page = 1;
      if (page == 1) {
        yield ExplorePlacesProgress();
      }
      //   try {
      final places = await placeRepository.fetchPlaces(page);
      if (places.length == 0) {
        yield ExplorePlacesEmpty();
      } else {
        page++;
        yield ExplorePlacesSuccess(places: places);
      }
      /* } catch (error) {
        print("error");
        yield ExplorePlacesFailure(error: error.toString());
      }*/
    }
  }
}
