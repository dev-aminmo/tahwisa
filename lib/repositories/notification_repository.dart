import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tahwisa/repositories/models/notification.dart';

import 'api/api_endpoints.dart';

class NotificationRepository {
  Future<dynamic> fetchNotifications() async {
    var pref = await SharedPreferences.getInstance();
    String token = pref.getString("token");
    var response = await Dio().get(Api.get_notifications,
        options: Options(
          headers: {"Authorization": "Bearer " + token},
        ));
    var data = await response.data;
    List<Notification> notifications = [];
    if (response.statusCode == 200) {
      for (var jsonReview in data['data']) {
        var notification = Notification.fromJson(jsonReview);
        notifications.add(notification);
      }
      return notifications;
    }
    return false;
  }
}
