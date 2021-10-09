import 'package:meta/meta.dart';
import 'package:tahwisa/repositories/models/place.dart';

@immutable
abstract class WishListState {}

class WishListInitial extends WishListState {}

class WishListProgress extends WishListState {}

class WishListEmpty extends WishListState {}

class WishListSuccess extends WishListState {
  final List<Place> places;
  final int numPages;
  WishListSuccess({@required this.places, @required this.numPages});

  bool canLoadMore(int page) => page + 1 <= numPages;
}

class WishListFailure extends WishListState {
  final String error;

  WishListFailure({@required this.error});

  @override
  String toString() => 'WishListFailure { error: $error }';
}
