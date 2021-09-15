import 'package:flutter/foundation.dart';

class User {
  String profilePicture;
  int id;
  String name;
  String email;

  User(
      {this.profilePicture,
      @required this.id,
      @required this.name,
      this.email});

  User.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['username'];
    this.email = json['email'];
    this.profilePicture = json['profile_picture'];
  }
  @override
  String toString() => "id:$id ,name: $name, ";
}
