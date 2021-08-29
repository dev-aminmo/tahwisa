import 'package:flutter_tagging/flutter_tagging.dart';

class Tag extends Taggable {
  int id;
  String name;
  String picture;

  /// Creates Tag
  Tag({
    final this.name = "",
  });
  Tag.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.picture = json['picture'];
  }

  @override
  List<Object> get props => [name];

  @override
  String toString() => name;
}
