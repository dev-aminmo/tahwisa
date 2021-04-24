import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/repositories/models/place.dart';

@immutable
abstract class ExplorePlacesState extends Equatable {
  const ExplorePlacesState();
  @override
  List<Object> get props => [];
}

class ExplorePlacesInitial extends ExplorePlacesState {}

class ExplorePlacesProgress extends ExplorePlacesState {}

class ExplorePlacesEmpty extends ExplorePlacesState {}

class ExplorePlacesSuccess extends ExplorePlacesState {
  final List<Place> places;
  ExplorePlacesSuccess({@required this.places});
  @override
  List<Object> get props => [places];
}

class ExplorePlacesFailure extends ExplorePlacesState {
  final String error;

  const ExplorePlacesFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ExplorePlacesFailure { error: $error }';
}
