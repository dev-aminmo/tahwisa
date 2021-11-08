import 'package:flutter/foundation.dart';

class Notification {
  var id;
  var title;
  var body;
  var description;
  bool read = false;
  var type;
  var placeId;
  var createdAt;
  var updatedAt;

  Notification(
      {@required this.id,
      this.title,
      this.body,
      this.description,
      this.read = false,
      @required this.type,
      this.placeId,
      this.createdAt,
      this.updatedAt});

  Notification.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.title = json['title'];
    this.body = json['body'];
    this.description = json['description'];
    this.read = json['read'];
    this.type = json['type'];
    this.placeId = json['place_id'];
    this.createdAt = json['created_at'];
    this.updatedAt = json['updated_at'];
  }
  @override
  String toString() =>
      "id: $id ,title: $title,body: $body , description: $description";
}
