import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/src/repositories/place_repository.dart';

part 'wish_place_state.dart';

class WishPlaceCubit extends Cubit<WishPlaceState> {
  final PlaceRepository placeRepository;

  WishPlaceCubit({required this.placeRepository}) : super(WishPlaceInitial());
  void addToWishList(var placeId) async {
    try {
      var response = await placeRepository.addToWishList(placeId: placeId);
      if (response) {
        emit(AddedToWishListSuccess(placeId: placeId));
      } else {
        emit(WishPlaceFailure(error: "An error occurred"));
      }
    } catch (error) {
      emit(WishPlaceFailure(error: error.toString()));
    }
  }

  void removeFromWishList(var placeId) async {
    try {
      var response = await placeRepository.deleteFromWishList(placeId: placeId);
      if (response) {
        emit(RemovedFromWishListSuccess(placeId: placeId));
      } else {
        emit(WishPlaceFailure(error: "An error occurred"));
      }
    } catch (error) {
      emit(WishPlaceFailure(error: error.toString()));
    }
  }
}
