import 'dart:convert';

import 'package:meta/meta.dart';
import 'api/api_endpoints.dart';
import 'package:dio/dio.dart';

class UserRepository {
  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    try {
      var response = await Dio().post(
        Api.login,
        data: {"email": username, "password": password},
      );
      print(response.data["token"]);
      // await Future.delayed(Duration(milliseconds: 100));
      return response.data["token"];
    } catch (e) {
      throw (e);
    }
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await Future.delayed(Duration(milliseconds: 100));
    return;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    await Future.delayed(Duration(milliseconds: 100));
    return;
  }

  Future<bool> hasToken() async {
    /// read from keystore/keychain
    await Future.delayed(Duration(milliseconds: 100));
    return false;
  }

  Future<dynamic> user() async {
    /// read from keystore/keychain
    await Future.delayed(Duration(milliseconds: 100));
    try {
      print(Api.user);
      Response response = await Dio().get(Api.user);
      print(response);
    } catch (e) {
      throw (e);
    }
    return null;
  }
}
