import 'package:flutter_tagging/flutter_tagging.dart';

class Tag extends Taggable {
  var id;
  var name;
  var picture;

  /// Creates Tag
  Tag({this.name, this.id});
  Tag.fromJson(Map<String, dynamic> json) {
    this.id = json['id'] ?? json['tag_id'];
    this.name = json['name'];
    this.picture = json['picture'];
  }

  @override
  List<Object> get props => [name];

  @override
  String toString() => "$id, $name , $picture";

  Map<String, dynamic> toJson() {
    return (this.id == null)
        ? {"name": this.name}
        : {"name": this.name, "id": this.id};
  }
}
