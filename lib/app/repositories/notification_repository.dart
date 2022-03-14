import 'package:tahwisa/app/repositories/models/notification.dart';
import 'package:tahwisa/app/utilities/dio_http_client.dart';

import 'api/api_endpoints.dart';

class NotificationRepository {
  Future<List<Notification>> fetchNotifications() async {
    var response = await DioHttpClient.getWithHeader(
      Api.get_notifications,
    );
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
    var response =
        await DioHttpClient.getWithHeader(Api.read_notification + "/$id");
    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }
}
