import 'package:dio/dio.dart';
import 'package:tahwisa/repositories/models/tag.dart';

import 'api/api_endpoints.dart';

class TagRepository {
  /// Mocks fetching Tags from network API with delay of 500ms.

  Future<List<Tag>> getTags(String query) async {
    var response = await Dio().get(Api.tags + "?query=$query");
    print(response.data);
    var data = response.data;
    List<Tag> tags = [];

    for (var jsonTag in data) {
      var tag = Tag.fromJson(jsonTag);
      tags.add(tag);
    }

    return tags
        .where((tag) => tag.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
