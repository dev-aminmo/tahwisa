import 'package:flutter/foundation.dart';

class Place {
  String id;
  String title;
  String description;
  double latitude;
  double longitude;
  String municipal;
  String state;
  double reviewsAverage;
  List<String> pictures;

  Place(
      {this.id,
      @required this.title,
      this.description,
      this.latitude,
      this.longitude,
      this.municipal,
      this.state,
      this.reviewsAverage,
      this.pictures});

  Place.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.title = json['username'];
    this.description = json['email'];
    this.latitude = json['profile_picture'];
    this.longitude = json['profile_picture'];
    this.municipal = json['profile_picture'];
    this.state = json['profile_picture'];
    this.reviewsAverage = json['profile_picture'];
    this.pictures = json['profile_picture'];
  }
}
