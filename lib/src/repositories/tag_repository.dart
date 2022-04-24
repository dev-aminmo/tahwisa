import 'package:tahwisa/src/repositories/models/tag.dart';
import 'package:tahwisa/src/utilities/dio_http_client.dart';

import 'api/api_endpoints.dart';

class TagRepository {
  /// Mocks fetching Tags from network API with delay of 500ms.
  List<Tag> tags = [];
  Future<List<Tag>> getTags(String query) async {
    if (query == '' && (this.tags.length != 0)) {
      print(this.tags.first);
      return this.tags;
    }
    var response =
        await DioHttpClient.getWithHeader(Api.tags + "?query=$query");
    var data = response.data;
    List<Tag> tags = [];

    for (var jsonTag in data) {
      var tag = Tag.fromJson(jsonTag);
      tags.add(tag);
    }
    if (query == '') {
      return this.tags = tags;
    }
    return tags
        .where((tag) => tag.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<List<Tag>> getTopTags() async {
    var response = await DioHttpClient.getWithHeader(Api.tags + "/top");
    var data = response.data;
    List<Tag> tags = [];
    for (var jsonTag in data["data"]) {
      var tag = Tag.fromJson(jsonTag);
      tags.add(tag);
    }
    return tags;
  }
}
