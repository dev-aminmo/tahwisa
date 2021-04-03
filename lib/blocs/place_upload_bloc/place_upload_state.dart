import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'bloc.dart';
import 'package:equatable/equatable.dart';


@immutable
abstract class PlaceUploadState extends Equatable{
const PlaceUploadState();
  @override
  List<Object> get props => [];
}

class PlaceUploadInitial extends PlaceUploadState {}

class PlaceUploadLoading extends PlaceUploadState {}

class PlaceUploadSuccess extends PlaceUploadState {}

class PlaceUploadFailure extends PlaceUploadState {
  final String error;

  const PlaceUploadFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'PlaceUploadFailure { error: $error }';
}
