import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tahwisa/app/repositories/models/notification.dart';

import 'api/api_endpoints.dart';

class NotificationRepository {
  Future<List<Notification>> fetchNotifications() async {
    var pref = await SharedPreferences.getInstance();
    String token = pref.getString("token")!;
    var response = await Dio().get(Api.get_notifications,
        options: Options(
          headers: {"Authorization": "Bearer " + token},
        ));
    var data = await response.data;
    List<Notification> notifications = [];
    if (response.statusCode == 200) {
      for (var jsonNotification in data['data']) {
        var notification = Notification.fromJson(jsonNotification);
        notifications.add(notification);
      }
      return notifications;
    }
    return [];
  }

  Future<dynamic> readNotification({var id}) async {
    var pref = await SharedPreferences.getInstance();
    String token = pref.getString("token")!;
    var response = await Dio().put(Api.read_notification + "/$id",
        options: Options(
          headers: {"Authorization": "Bearer " + token},
        ));
    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }
}
