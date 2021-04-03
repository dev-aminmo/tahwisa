import 'bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'dart:async';
import 'dart:io';

@immutable
abstract class PlaceUploadEvent extends Equatable{
  const PlaceUploadEvent();
}

class UploadPlaceButtonPressed extends PlaceUploadEvent {
  final String title;
  final String description;
  final String  picture;
  final int municipalID;
  final double latitude;
  final double longitude;


  UploadPlaceButtonPressed({
    @required this.title,
    @required this.description,
    @required this.picture,
    @required this.municipalID,
    @required this.latitude,
    @required this.longitude});

  @override
  List<Object> get props => [title, description,picture,municipalID,latitude,longitude];

  @override
  String toString() =>
      'LoginButtonPressed { $title, $description,$picture,$municipalID, $latitude, $longitude }';
}
