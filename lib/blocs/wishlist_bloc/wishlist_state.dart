import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/repositories/models/place.dart';

@immutable
abstract class WishListState extends Equatable {
  const WishListState();
  @override
  List<Object> get props => [];
}

class WishListInitial extends WishListState {}

class WishListProgress extends WishListState {}

class WishListEmpty extends WishListState {}

class WishListSuccess extends WishListState {
  final List<Place> places;
  final int numPages;
  WishListSuccess({@required this.places, @required this.numPages});
  @override
  List<Object> get props => [places];
}

class WishListFailure extends WishListState {
  final String error;

  const WishListFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'WishListFailure { error: $error }';
}
