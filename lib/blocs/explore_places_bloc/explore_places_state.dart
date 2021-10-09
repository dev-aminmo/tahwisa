import 'package:meta/meta.dart';
import 'package:tahwisa/repositories/models/place.dart';

@immutable
abstract class ExplorePlacesState {}

class ExplorePlacesInitial extends ExplorePlacesState {}

class ExplorePlacesProgress extends ExplorePlacesState {}

class ExplorePlacesEmpty extends ExplorePlacesState {}

class ExplorePlacesSuccess extends ExplorePlacesState {
  final List<Place> places;
  final int numPages;
  ExplorePlacesSuccess({@required this.places, @required this.numPages});

  bool canLoadMore(int page) => page + 1 <= numPages;
}

class ExplorePlacesFailure extends ExplorePlacesState {
  final String error;

  ExplorePlacesFailure({@required this.error});
  @override
  String toString() => 'ExplorePlacesFailure { error: $error }';
}
