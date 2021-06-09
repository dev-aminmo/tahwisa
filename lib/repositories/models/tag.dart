import 'package:flutter_tagging/flutter_tagging.dart';

class Tag extends Taggable {
  String name;

  /// Creates Tag
  Tag({
    final this.name = "",
  });
  Tag.fromJson(Map<String, dynamic> json) {
    this.name = json['name'];
  }

  @override
  List<Object> get props => [name];

  @override
  String toString() => name;
}
