import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/api_endpoints.dart';
import 'models/place.dart';

class PlaceRepository {
  Future<dynamic> fetchPlaces(int page) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String token = pref.getString("token");
      var response = await Dio().get(Api.all_places + "?page=$page",
          options: Options(
            headers: {"Authorization": "Bearer " + token},
            validateStatus: (status) => true,
          ) // options.headers["Authorization"] = "Bearer " + token;

          );
      var data = response.data;
      List<Place> places = [];
      for (var jsonPlace in data['data']) {
        var place = Place.fromJson(jsonPlace);
        places.add(place);
      }
      return places;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<dynamic> search(String pattern) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String token = pref.getString("token");
      var response = await Dio().get(Api.search_places + "?query=$pattern",
          options: Options(
            headers: {"Authorization": "Bearer " + token},
            validateStatus: (status) => true,
          ) // options.headers["Authorization"] = "Bearer " + token;

          );
      var data = response.data;
      List<Place> places = [];
      for (var jsonPlace in data['data']) {
        var place = Place.fromJson(jsonPlace);
        places.add(place);
      }
      return places;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<dynamic> fetchWishListPlaces(int page) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String token = pref.getString("token");
      var response = await Dio().get(Api.wishes + "?page=$page",
          options: Options(
            headers: {"Authorization": "Bearer " + token},
            validateStatus: (status) => true,
          ) // options.headers["Authorization"] = "Bearer " + token;

          );
      var data = response.data;
      List<Place> places = [];
      for (var jsonPlace in data['data']) {
        var place = Place.fromJson(jsonPlace);
        places.add(place);
      }
      return places;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<dynamic> add({
    String title,
    String description,
    List<File> pictures,
    int municipalID,
    double latitude,
    double longitude,
  }) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String token = pref.getString("token");
      var formData = FormData.fromMap({
        'data': {
          "title": title,
          "description": description,
          "latitude": latitude,
          "longitude": longitude,
          "municipal_id": municipalID
        },
        'file[]': await _picturesToMultipartFile(pictures)
      });
      var response = await Dio().post(Api.add_place,
          data: formData,
          options: Options(
            headers: {
              "Authorization": "Bearer " + token,
              "Accept": "multipart/mixed",
              "Content-Type": "multipart/form-data",
            },
            validateStatus: (status) => true,
          ));
      var data = response.data;
      print(data);
      if (response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<List> _picturesToMultipartFile(pictures) async {
    var list = [];
    for (var item in pictures) {
      var i = await MultipartFile.fromFile(item.path);
      list.add(i);
    }
    return list;
  }
}
