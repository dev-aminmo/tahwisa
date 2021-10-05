part of 'wish_place_cubit.dart';

@immutable
abstract class WishPlaceState extends Equatable {
  const WishPlaceState();
  @override
  List<Object> get props => [];
}

class WishPlaceInitial extends WishPlaceState {}

class WishPlaceProgress extends WishPlaceState {}

class AddedToWishListSuccess extends WishPlaceState {}

class RemovedFromWishListSuccess extends WishPlaceState {}

class WishPlaceFailure extends WishPlaceState {
  final String error;
  const WishPlaceFailure({@required this.error});
  @override
  List<Object> get props => [error];
  @override
  String toString() => 'WishPlaceFailure { error: $error }';
}
