import 'dart:convert';

import 'package:tahwisa/src/utilities/dio_http_client.dart';

import 'api/api_endpoints.dart';

class AdminRepository {
  Future<dynamic> checkIfPlaceIsAvailable({
    required var placeId,
  }) async {
    var response = await DioHttpClient.getWithHeader(
        Api.check_if_place_is_available + "/$placeId");
    print("check if is available ${response.statusCode}");
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<dynamic> approvePlace({
    required var placeId,
  }) async {
    var response =
        await DioHttpClient.postWithHeader(Api.approve_place + "/$placeId");
    print("approve place ${response.statusCode}");
    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }

  Future<dynamic> refusePlace(
      {required var placeId, required var messages, var description}) async {
    var formData = {"messages": messages, "description": description};
    var response = await DioHttpClient.postWithHeader(
      Api.refuse_place + "/$placeId",
      body: jsonEncode(formData),
    );
    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }
}
