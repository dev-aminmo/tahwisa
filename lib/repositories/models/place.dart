import 'package:flutter/foundation.dart';

class Place {
  /* int id;
  String title;
  String description;
  double latitude;
  double longitude;
  double municipal;
  String state;
  double reviewsAverage;*/
  var id;
  var title;
  var description;
  var latitude;
  var longitude;
  var municipal;
  var state;
  var reviewsAverage;
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
    this.title = json['title'];
    this.description = json['description'];
    this.latitude = json['latitude'];
    this.longitude = json['longitude'];
    this.municipal = json['municipal_id'];
    //this.state = json['profile_picture'];
    this.reviewsAverage = json['reviews_avg_vote'];

    // this.pictures = json['pictures'];
    if (json['pictures'] != null) {
      pictures = [];
      json['pictures'].forEach((p) {
        pictures.add(p['path']);
      });
    }
  }
}
