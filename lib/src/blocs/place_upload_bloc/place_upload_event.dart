import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/src/repositories/models/tag.dart';

@immutable
abstract class PlaceUploadEvent extends Equatable {
  const PlaceUploadEvent();
}

class UploadPlaceButtonPressed extends PlaceUploadEvent {
  final String title;
  final String description;
  final List<File> picture;
  final int? municipalID;
  final double latitude;
  final double longitude;
  final List<Tag>? tags;

  UploadPlaceButtonPressed({
    required this.title,
    required this.description,
    required this.picture,
    required this.municipalID,
    required this.latitude,
    required this.longitude,
    required this.tags,
  });

  @override
  List<Object> get props =>
      [title, description, picture, municipalID!, latitude, longitude, tags!];

  @override
  String toString() =>
      'UploadPlaceButtonPressed { $title, $description,$picture,$municipalID, $latitude, $longitude ,$tags}';
}

class UpdatePlaceButtonPressed extends PlaceUploadEvent {
  final String title;
  final String description;
  final List<File>? pictures;
  final int? municipalID;
  final placeId;

  UpdatePlaceButtonPressed({
    required this.title,
    required this.description,
    this.pictures,
    required this.municipalID,
    required this.placeId,
  });

  @override
  List<Object> get props =>
      [title, description, pictures!, municipalID!, placeId];

  @override
  String toString() =>
      'UpdatePlaceButtonPressed { $title, $description,$pictures,$municipalID,$placeId}';
}
