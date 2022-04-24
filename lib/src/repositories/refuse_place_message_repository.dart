import 'package:tahwisa/src/utilities/dio_http_client.dart';

import 'api/api_endpoints.dart';
import 'models/refuse_place_message.dart';

class RefusePlaceMessageRepository {
  Future<dynamic> getRefusePlaceMessages({
    required var notificationId,
  }) async {
    var response = await DioHttpClient.getWithHeader(
        Api.get_refuse_messages + "/$notificationId");
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
    var response =
        await DioHttpClient.getWithHeader(Api.get_admin_refuse_messages);
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
