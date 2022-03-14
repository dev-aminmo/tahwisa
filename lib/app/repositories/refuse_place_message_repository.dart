import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/api_endpoints.dart';
import 'models/refuse_place_message.dart';

class RefusePlaceMessageRepository {
  Future<dynamic> getRefusePlaceMessages({
    required var notificationId,
  }) async {
    var pref = await SharedPreferences.getInstance();
    String token = pref.getString("token")!;
    var response = await Dio().get(Api.get_refuse_messages + "/$notificationId",
        options: Options(
          headers: {"Authorization": "Bearer " + token},
        ));
    var data = await response.data;
    print(data);
    List<RefusePlaceMessage> messages = [];
    if (response.statusCode == 200) {
      for (var jsonMessage in data['data']) {
        var message = RefusePlaceMessage.fromJson(jsonMessage);
        messages.add(message);
      }
      return messages;
    }
    throw ("An error occurred");
  }

  Future<dynamic> getAdminRefusePlaceMessages() async {
    var pref = await SharedPreferences.getInstance();
    String token = pref.getString("token")!;
    var response = await Dio().get(Api.get_admin_refuse_messages,
        options: Options(
          headers: {"Authorization": "Bearer " + token},
        ));
    var data = await response.data;
    List<RefusePlaceMessage> messages = [];
    if (response.statusCode == 200) {
      for (var jsonMessage in data['data']) {
        var message = RefusePlaceMessage.fromJson(jsonMessage);
        messages.add(message);
      }
      return messages;
    }
    throw ("An error occurred");
  }
}
