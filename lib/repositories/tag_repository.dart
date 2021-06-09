import 'package:tahwisa/repositories/models/tag.dart';

class TagRepository {
  /// Mocks fetching Tags from network API with delay of 500ms.
  static Future<List<Tag>> getTags(String query) async {
    await Future.delayed(Duration(milliseconds: 500), null);
    return <Tag>[
      Tag(name: 'JavaScript'),
      Tag(name: 'Python'),
      Tag(name: 'Java'),
      Tag(name: 'PHP'),
      Tag(name: 'C#'),
      Tag(name: 'C++'),
    ]
        .where((tag) => tag.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
