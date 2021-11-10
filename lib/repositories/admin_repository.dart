import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/api_endpoints.dart';

class AdminRepository {
  Future<dynamic> checkIfPlaceIsAvailable({
    @required var placeId,
  }) async {
    var pref = await SharedPreferences.getInstance();
    String token = pref.getString("token");
    var response =
        await Dio().get(Api.check_if_place_is_available + "/$placeId",
            options: Options(
              headers: {"Authorization": "Bearer " + token},
            ));
    print("check if is available ${response.statusCode}");
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<dynamic> approvePlace({
    @required var placeId,
  }) async {
    var pref = await SharedPreferences.getInstance();
    String token = pref.getString("token");
    var response = await Dio().post(Api.approve_place + "/$placeId",
        options: Options(
          headers: {"Authorization": "Bearer " + token},
        ));
    print("approve place ${response.statusCode}");
    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }

  Future<dynamic> refusePlace(
      {@required var placeId, @required List<int> messages}) async {
    var pref = await SharedPreferences.getInstance();
    String token = pref.getString("token");
    var response = await Dio().post(Api.approve_place + "/$placeId",
        options: Options(
          headers: {"Authorization": "Bearer " + token},
        ));
    print("approve place ${response.statusCode}");
    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }
}
