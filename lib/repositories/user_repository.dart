import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/api_endpoints.dart';

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
      if (response.statusCode != 201) {
        print(response.toString());
        throw ("verify  your data");
      }
      return response.data["token"];
    } catch (e) {
      throw ("error occurred");
    }
  }

  Future<String> social({
    @required String accessToken,
  }) async {
    try {
      var response = await Dio().post(
        Api.social,
        data: {"access_token": accessToken},
      );
      if (response.statusCode != 201) {
        print(response.toString());
        throw ("cannot log in with this account");
      }
      return response.data["token"];
    } catch (e) {
      throw ("error occurred");
    }
  }

  Future<bool> resetPassword({
    @required String email,
  }) async {
    try {
      var response = await Dio().post(
        Api.resetPassword,
        data: {"email": email},
      );
      if (response.statusCode == 200) return true;

      return false;
    } catch (e) {
      //throw ("Could not found an account with that email address");
      rethrow;
    }
  }

  Future<void> deleteToken() async {
    await SharedPreferences.getInstance()
      ..remove("token");
  }

  Future<void> persistToken(String token) async {
    await SharedPreferences.getInstance()
      ..setString("token", token);
  }

  Future<bool> hasToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.containsKey("token");
  }

  Future<dynamic> user() async {
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
