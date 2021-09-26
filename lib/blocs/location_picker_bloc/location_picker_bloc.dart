import 'dart:async';

import 'package:bloc/bloc.dart';

import 'bloc.dart';

class LocationPickerBloc
    extends Bloc<LocationPickerEvent, LocationPickerState> {
  LocationPickerBloc() : super(LocationPickerInitial());

  @override
  Stream<LocationPickerState> mapEventToState(
    LocationPickerEvent event,
  ) async* {
    if (event is PickLocation) {
      print("event_is heree");
      yield (LocationPickerLoading());
    }
    if (event is PickCanceled) {
      yield (LocationPickerInitial());
    }
    if (event is LocationChosen) {
      yield (LocationPicked(
        latitude: event.latitude,
        longitude: event.longitude,
      ));
    }
  }
}
