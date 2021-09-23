import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/repositories/models/place.dart';
import 'package:tahwisa/repositories/place_repository.dart';

part 'place_details_state.dart';

class PlaceDetailsCubit extends Cubit<PlaceDetailsState> {
  final placeID;
  final place;
  final PlaceRepository placeRepository;

  PlaceDetailsCubit({this.place, this.placeID, @required this.placeRepository})
      : super(PlaceDetailsProgress()) {
    fetchPlaceDetails();
  }

  void fetchPlaceDetails() async {
    if (place != null) {
      emit(PlaceDetailsSuccess(place: place));
    } else {
      print("else");
      var response = await placeRepository.fetchPlace(placeID);
      if (response is Place) {
        emit(PlaceDetailsSuccess(place: response));
      } else {
        emit(PlaceDetailsFailure(error: response));
      }
    }
  }
}
