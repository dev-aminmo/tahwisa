import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/app/blocs/wishlist_bloc/bloc.dart';

@immutable
abstract class WishListEvent extends Equatable {
  const WishListEvent();
  @override
  List<Object> get props => [];
}

class FetchFirstPageWishList extends WishListEvent {
  final bool loading;
  FetchFirstPageWishList({this.loading = true});
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
