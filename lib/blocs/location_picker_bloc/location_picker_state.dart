import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LocationPickerState extends Equatable {
  const LocationPickerState();
  @override
  List<Object> get props => [];
}

class LocationPickerInitial extends LocationPickerState {}

class LocationPickerLoading extends LocationPickerState {}

class LocationPicked extends LocationPickerState {
  final double latitude;
  final double longitude;

  LocationPicked({@required this.latitude, @required this.longitude});

  @override
  List<Object> get props => [latitude, longitude];
}

class LocationPickerFailure extends LocationPickerState {
  final String error;

  const LocationPickerFailure({
    @required this.error,
  });

  @override
  List<Object> get props => [error];

  @override
  String toString() => ' { error: $error }';
}
