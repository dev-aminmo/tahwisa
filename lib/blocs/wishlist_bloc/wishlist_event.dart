import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/blocs/wishlist_bloc/bloc.dart';

@immutable
abstract class WishListEvent extends Equatable {
  const WishListEvent();
  @override
  List<Object> get props => [];
}

class FetchFirstPageWishList extends WishListEvent {
  FetchFirstPageWishList();
}

class FetchWishListPageRequested extends WishListEvent {
  final WishListSuccess state;
  const FetchWishListPageRequested(this.state);

  @override
  List<Object> get props => [state];

  @override
  String toString() {
    return 'FetchWishListPageRequested { state : $state }';
  }
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
