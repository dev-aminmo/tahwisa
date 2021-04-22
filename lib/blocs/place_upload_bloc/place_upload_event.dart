import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PlaceUploadEvent extends Equatable {
  const PlaceUploadEvent();
}

class UploadPlaceButtonPressed extends PlaceUploadEvent {
  final String title;
  final String description;
  final List<File> picture;
  final int municipalID;
  final double latitude;
  final double longitude;

  UploadPlaceButtonPressed(
      {@required this.title,
      @required this.description,
      @required this.picture,
      @required this.municipalID,
      @required this.latitude,
      @required this.longitude}) {
    print(this.toString());
  }

  @override
  List<Object> get props =>
      [title, description, picture, municipalID, latitude, longitude];

  @override
  String toString() =>
      'LoginButtonPressed { $title, $description,$picture,$municipalID, $latitude, $longitude }';
}
