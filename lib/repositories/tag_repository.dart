import 'package:dio/dio.dart';
import 'package:tahwisa/repositories/models/tag.dart';

import 'api/api_endpoints.dart';

class TagRepository {
  /// Mocks fetching Tags from network API with delay of 500ms.
  bool _fetched = false;
  List<Tag> tags = [];

  Future<List<Tag>> getTags(String query) async {
    //TODO query tags
    if (!_fetched) {
      _fetched = true;
      var response = await Dio().get(Api.tags);
      print(response.data);
      var data = response.data;
      for (var jsonTag in data) {
        var tag = Tag.fromJson(jsonTag);
        tags.add(tag);
      }
    }

    return tags
        .where((tag) => tag.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
