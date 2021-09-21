import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'user.dart';

class Review extends Equatable {
  var id;
  var rating;
  var comment;
  var placeId;
  User user;
  var createdAt;

  Review({
    @required this.id,
    @required this.rating,
    this.comment,
    this.placeId,
    this.user,
    this.createdAt,
  });

  Review.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.rating = json['vote'];
    this.comment = json['comment'];
    this.placeId = json['place_id'];
    this.user = User.fromJson(json['user']);
    this.createdAt = json['created_at'];
  }
  @override
  List<Object> get props => [
        this.id,
        this.rating,
        this.comment,
        this.placeId,
        this.user,
        this.createdAt,
      ];

  @override
  bool get stringify => true;
}
