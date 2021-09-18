import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Review extends Equatable {
  var id;
  var vote;
  var comment;
  var placeId;
  var userId;
  var createdAt;

  Review({
    @required this.id,
    @required this.vote,
    this.comment,
    this.placeId,
    this.userId,
    this.createdAt,
  });

  Review.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.vote = json['vote'];
    this.comment = json['comment'];
    this.placeId = json['place_id'];
    this.userId = json['user_id'];
    this.createdAt = json['created_at'];
  }
  @override
  List<Object> get props => [
        this.id,
        this.vote,
        this.comment,
        this.placeId,
        this.userId,
        this.createdAt,
      ];

  @override
  bool get stringify => true;
}
