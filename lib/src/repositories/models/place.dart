import 'package:equatable/equatable.dart';

import 'tag.dart';
import 'user.dart';

class Place extends Equatable {
  var id;
  var title;
  var description;
  var latitude;
  var longitude;
  var municipal;
  var state;
  var reviewsAverage;
  var reviewsCount;
  var wished;
  List<Tag>? tags;
  User? user;
  List<String?>? pictures;

  Place({
    required this.id,
    required this.title,
    this.description,
    this.latitude,
    this.longitude,
    this.municipal,
    this.state,
    this.reviewsAverage,
    this.reviewsCount,
    this.wished,
    this.pictures,
    this.tags,
    this.user,
  });
  Place.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.title = json['title'];
    this.description = json['description'];
    this.latitude = json['latitude'];
    this.longitude = json['longitude'];
    this.municipal =
        json['municipal_id'] == null ? null : json['municipal_id']['name_fr'];
    this.state = json['municipal_id'] == null
        ? null
        : json['municipal_id']['state']['name_fr'];
    this.reviewsAverage = (json['reviews_avg_vote'] == null)
        ? 0.0
        : double.parse(json['reviews_avg_vote']);
    this.reviewsCount = json['reviews_count'];
    this.wished = json['wished'];
    this.user = (json['user'] != null) ? User.fromJson(json['user']) : null;
    if (json['tags'] != null) {
      this.tags = [];
      json['tags'].forEach((tag) {
        tags!.add(Tag.fromJson(tag));
      });
    }
    // this.pictures = json['pictures'];
    if (json['pictures'] != null) {
      pictures = [];
      json['pictures'].forEach((p) {
        pictures!.add(p['path']);
      });
    }
  }
  @override
  List<Object> get props => [
        this.id,
        this.title,
        this.description,
        this.latitude,
        this.longitude,
        this.municipal,
        this.state,
        this.reviewsAverage,
        this.reviewsCount,
        this.wished,
        this.pictures!,
        this.tags!,
        this.user!,
      ];

  @override
  bool get stringify => true;
}
