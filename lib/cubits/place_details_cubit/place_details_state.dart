part of 'place_details_cubit.dart';

@immutable
abstract class PlaceDetailsState extends Equatable {
  const PlaceDetailsState();
  @override
  List<Object> get props => [];
}

class PlaceDetailsInitial extends PlaceDetailsState {}

class PlaceDetailsProgress extends PlaceDetailsState {}

class PlaceDetailsEmpty extends PlaceDetailsState {}

class PlaceDetailsSuccess extends PlaceDetailsState {
  final Place place;
  PlaceDetailsSuccess({@required this.place});
  @override
  List<Object> get props => [place];
}

class PlaceDetailsFailure extends PlaceDetailsState {
  final String error;

  const PlaceDetailsFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'PlaceDetailsFailure { error: $error }';
}
