import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/api_endpoints.dart';
import 'models/refuse_place_message.dart';

class RefusePlaceMessageRepository {
  Future<dynamic> getRefusePlaceMessages({
    @required var placeId,
  }) async {
    var pref = await SharedPreferences.getInstance();
    String token = pref.getString("token");
    var response = await Dio().get(Api.get_refuse_messages + "/$placeId",
        options: Options(
          headers: {"Authorization": "Bearer " + token},
        ));
    var data = await response.data;
    List<RefusePlaceMessage> messages = [];
    if (response.statusCode == 200) {
      for (var jsonReview in data['data']) {
        var notification = RefusePlaceMessage.fromJson(jsonReview);
        messages.add(notification);
      }
      return messages;
    }
    throw ("An error occurred");
  }

  Future<dynamic> getAdminRefusePlaceMessages() async {
    var pref = await SharedPreferences.getInstance();
    String token = pref.getString("token");
    var response = await Dio().get(Api.get_admin_refuse_messages,
        options: Options(
          headers: {"Authorization": "Bearer " + token},
        ));
    var data = await response.data;
    List<RefusePlaceMessage> messages = [];
    if (response.statusCode == 200) {
      for (var jsonReview in data['data']) {
        var notification = RefusePlaceMessage.fromJson(jsonReview);
        messages.add(notification);
      }
      return messages;
    }
    return false;
  }
}
