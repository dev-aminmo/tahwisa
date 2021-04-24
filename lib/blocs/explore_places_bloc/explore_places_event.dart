import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ExplorePlacesEvent extends Equatable {
  const ExplorePlacesEvent();
  @override
  List<Object> get props => [];
}

class PlaceFetched extends ExplorePlacesEvent {
  final bool refresh;

  PlaceFetched({this.refresh = false});
}
