import 'package:shared_preferences/shared_preferences.dart';
import 'package:tahwisa/app/repositories/models/user.dart';
import 'package:tahwisa/app/utilities/dio_http_client.dart';

import 'api/api_endpoints.dart';

class UserRepository {
  Future<String?> authenticate({
    required String email,
    required String password,
  }) async {
    try {
      var response = await DioHttpClient.post(
        Api.login,
        body: {"email": email, "password": password},
      );
      return response.data["token"];
    } catch (e) {
      throw ("Incorrect email and password");
    }
  }

  Future<String?> register({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      var response = await DioHttpClient.post(
        Api.register,
        body: {"username": username, "email": email, "password": password},
      );
      if (response.statusCode != 201) {
        throw ("verify  your data");
      }
      return response.data["token"];
    } catch (e) {
      throw ("error occurred");
    }
  }

  Future<String?> social({
    required String accessToken,
  }) async {
    try {
      var response = await DioHttpClient.post(
        Api.social,
        body: {"access_token": accessToken},
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
    required String email,
  }) async {
    try {
      var response = await DioHttpClient.post(
        Api.resetPassword,
        body: {"email": email},
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
      var response = await DioHttpClient.getWithHeader(
        Api.user,
      );
      var data = response.data;
      User user = User.fromJson(data['data']);
      return user;
    } catch (e) {
      throw (e);
    }
  }
}
