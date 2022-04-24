import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:tahwisa/src/repositories/place_repository.dart';

import 'bloc.dart';

class PlaceUploadBloc extends Bloc<PlaceUploadEvent, PlaceUploadState> {
  final PlaceRepository placeRepository;

  PlaceUploadBloc({
    required this.placeRepository,
  }) : super(PlaceUploadInitial());

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
            longitude: event.longitude,
            tags: event.tags!);
        if (response) {
          yield (PlaceUploadSuccess());
        } else {
          yield PlaceUploadFailure(error: "An error occurred");
        }
      } catch (error) {
        yield PlaceUploadFailure(error: error.toString());
      }
    }
    if (event is UpdatePlaceButtonPressed) {
      yield PlaceUploadLoading();
      try {
        var response = await placeRepository.update(
            title: event.title,
            description: event.description,
            pictures: event.pictures,
            municipalID: event.municipalID,
            placeId: event.placeId);
        if (response) {
          yield (PlaceUploadSuccess());
        } else {
          yield PlaceUploadFailure(error: "An error occurred");
        }
      } catch (error) {
        yield PlaceUploadFailure(error: error.toString());
      }
    }
  }
}
