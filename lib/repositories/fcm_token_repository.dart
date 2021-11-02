import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/api_endpoints.dart';

class FcmTokenRepository {
  Future<dynamic> add({
    @required String fcmToken,
  }) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String token = pref.getString("token");
      var formData = FormData.fromMap({"token": fcmToken});
      var response = await Dio().post(Api.add_fcm_token,
          data: formData,
          options: Options(
            headers: {
              "Authorization": "Bearer " + token,
            },
            validateStatus: (status) => true,
          ));
      var data = response.data;
      print(data);
      if (response.statusCode == 201) {
        await SharedPreferences.getInstance()
          ..setString("api_fcm_token", fcmToken);
        return true;
      }
      return false;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<dynamic> deleteToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      await messaging.deleteToken();
    } catch (e) {} finally {
      var pref = await SharedPreferences.getInstance();
      await pref.remove("api_fcm_token");
      await pref.remove("fcm_token");
    }
  }
}
