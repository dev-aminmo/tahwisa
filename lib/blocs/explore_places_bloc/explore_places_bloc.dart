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
      yield ExplorePlacesProgress();
      try {
        final places = await placeRepository.fetchPlaces();

        yield ExplorePlacesSuccess(places: places);
        // authenticationBloc.add(LoggedIn(token: token));
      } catch (error) {
        print("error");
        yield ExplorePlacesFailure(error: error.toString());
      }
    }
  }
}
