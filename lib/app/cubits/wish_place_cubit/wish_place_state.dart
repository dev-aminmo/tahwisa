part of 'wish_place_cubit.dart';

@immutable
abstract class WishPlaceState extends Equatable {
  const WishPlaceState();
  @override
  List<Object> get props => [];
}

class WishPlaceInitial extends WishPlaceState {}

class WishPlaceProgress extends WishPlaceState {}

class AddedToWishListSuccess extends WishPlaceState {
  final placeId;

  AddedToWishListSuccess({required this.placeId});

  @override
  List<Object> get props => [placeId];
}

class RemovedFromWishListSuccess extends WishPlaceState {
  final placeId;

  RemovedFromWishListSuccess({required this.placeId});

  @override
  List<Object> get props => [placeId];
}

class WishPlaceFailure extends WishPlaceState {
  final String error;
  const WishPlaceFailure({required this.error});
  @override
  List<Object> get props => [error];
  @override
  String toString() => 'WishPlaceFailure { error: $error }';
}
