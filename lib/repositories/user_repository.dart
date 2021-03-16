import 'dart:convert';

import 'package:meta/meta.dart';
import 'api/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  Future<String> authenticate({
    @required String email,
    @required String password,
  }) async {
    try {
      var response = await Dio().post(
        Api.login,
        data: {"email": email, "password": password},
      );
      //print(response.data["token"]);
      return response.data["token"];
    } catch (e) {
      throw ("Incorrect email and password");
    }
  }

  Future<String> register({
    @required String email,
    @required String username,
    @required String password,
  }) async {
    try {
      var response = await Dio().post(
        Api.register,
        data: {"username": username, "email": email, "password": password},
      );
      print("its goood****************************************");
      if (response.statusCode != 201) {
        print(response.toString());

        throw ("verify  your data");
      }

      return response.data["token"];
    } catch (e) {
      throw ("error occurred");
    }
  }

  Future<void> deleteToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("token");
    return;
  }

  Future<void> persistToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("token", token);
    return;
  }

  Future<bool> hasToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.containsKey("token");
    // await Future.delayed(Duration(milliseconds: 100));
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
