import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ExplorePlacesEvent extends Equatable {
  const ExplorePlacesEvent();
  @override
  List<Object> get props => [];
}

class FetchPlaces extends ExplorePlacesEvent {
  final bool refresh;

  FetchPlaces({this.refresh = false});
}
