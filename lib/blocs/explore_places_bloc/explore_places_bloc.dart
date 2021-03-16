import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'bloc.dart';

class ExplorePlacesBloc extends Bloc<ExplorePlacesEvent, ExplorePlacesState> {
  final placeRepository;
  ExplorePlacesBloc({@required this.placeRepository})
      : assert(placeRepository != null),
        super(ExplorePlacesInitial());
  @override
  Stream<ExplorePlacesState> mapEventToState(
    ExplorePlacesEvent event,
  ) async* {
    if (event is PlaceFetched) {
      print("event recieved************************");

      yield ExplorePlacesProgress();
      try {
        print("hello**************");
        final places = await placeRepository.fetchPlaces();

        yield ExplorePlacesSuccess(places: places);
        // authenticationBloc.add(LoggedIn(token: token));
      } catch (error) {
        yield ExplorePlacesFailure(error: error.toString());
      }
    }
  }
}
