import 'package:flutter_tagging/flutter_tagging.dart';

class Tag extends Taggable {
  final String name;

  /// Creates Tag
  Tag({
    this.name = "",
  });

  @override
  List<Object> get props => [name];
}
