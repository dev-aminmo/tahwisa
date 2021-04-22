import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/repositories/place_repository.dart';

import 'bloc.dart';

class PlaceUploadBloc extends Bloc<PlaceUploadEvent, PlaceUploadState> {
  final PlaceRepository placeRepository;

  PlaceUploadBloc({
    @required this.placeRepository,
  })  : assert(placeRepository != null),
        super(PlaceUploadInitial());
  @override
  PlaceUploadState get initialState => PlaceUploadInitial();
  @override
  Stream<PlaceUploadState> mapEventToState(
    PlaceUploadEvent event,
  ) async* {
    if (event is UploadPlaceButtonPressed) {
      yield PlaceUploadLoading();
      try {
        var response = await placeRepository.add(
            title: event.title,
            description: event.description,
            pictures: event.picture,
            municipalID: event.municipalID,
            latitude: event.latitude,
            longitude: event.longitude);
        if (response) {
          yield (PlaceUploadSuccess());
        }
      } catch (error) {
        yield PlaceUploadInitial();
        yield PlaceUploadFailure(error: error.toString());
      }
    }
  }
}
