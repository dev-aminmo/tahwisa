import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'explore_places_state.dart';

@immutable
abstract class ExplorePlacesEvent extends Equatable {
  const ExplorePlacesEvent();
  @override
  List<Object> get props => [];
}

class FetchFirstPageExplorePlaces extends ExplorePlacesEvent {}

class FetchExplorePlacesPageRequested extends ExplorePlacesEvent {
  final ExplorePlacesSuccess state;
  const FetchExplorePlacesPageRequested(this.state);

  @override
  List<Object> get props => [state];

  @override
  String toString() {
    return 'FetchExplorePlacesPageRequested { state : $state }';
  }
}
