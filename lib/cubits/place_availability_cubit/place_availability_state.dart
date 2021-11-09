part of 'place_availability_cubit.dart';

@immutable
abstract class PlaceAvailabilityState {}

class PlaceAvailabilityInitial extends PlaceAvailabilityState {}

class PlaceAvailable extends PlaceAvailabilityState {}

class PlaceUnAvailable extends PlaceAvailabilityState {}
