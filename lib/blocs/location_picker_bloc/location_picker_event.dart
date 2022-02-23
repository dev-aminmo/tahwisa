import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LocationPickerEvent extends Equatable {
  const LocationPickerEvent();
  @override
  List<Object> get props => [];
}

class PickLocation extends LocationPickerEvent {}

class PickCanceled extends LocationPickerEvent {}

class LocationChosen extends LocationPickerEvent {
  final double latitude;
  final double longitude;
  const LocationChosen({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];

  @override
  String toString() =>
      'LocationChosen { latitude: $latitude,longitude: $longitude }';
}
