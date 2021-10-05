import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WishListEvent extends Equatable {
  const WishListEvent();
  @override
  List<Object> get props => [];
}

class PlaceFetched extends WishListEvent {
  final bool refresh;

  PlaceFetched({this.refresh = false});
}

class AddToWishList extends WishListEvent {
  final placeId;

  AddToWishList({@required this.placeId});
  @override
  List<Object> get props => [placeId];
}

class RemoveFromWishList extends WishListEvent {
  final placeId;
  RemoveFromWishList({@required this.placeId});
  @override
  List<Object> get props => [placeId];
}
