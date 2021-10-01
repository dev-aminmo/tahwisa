import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tahwisa/repositories/models/tag.dart';

import 'api/api_endpoints.dart';

class TagRepository {
  /// Mocks fetching Tags from network API with delay of 500ms.
  List<Tag> tags = [];
  Future<List<Tag>> getTags(String query) async {
    if (query == '' && (this.tags.length != 0)) {
      print(this.tags.first);
      return this.tags;
    }
    var pref = await SharedPreferences.getInstance();
    String token = pref.getString("token");
    var response = await Dio().get(Api.tags + "?query=$query",
        options: Options(
          headers: {"Authorization": "Bearer " + token},
        ));
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
    var pref = await SharedPreferences.getInstance();
    String token = pref.getString("token");
    var response = await Dio().get(Api.tags + "/top",
        options: Options(
          headers: {"Authorization": "Bearer " + token},
        ));
    var data = response.data;
    List<Tag> tags = [];

    for (var jsonTag in data["data"]) {
      var tag = Tag.fromJson(jsonTag);
      tags.add(tag);
    }
    print(tags.length);

    return tags;
  }
}
