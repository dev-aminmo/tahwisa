import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tahwisa/repositories/models/query_response.dart';

import 'api/api_endpoints.dart';
import 'models/SearchFilter.dart';
import 'models/place.dart';
import 'models/tag.dart';

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
      for (var jsonPlace in data['data']['data']) {
        var place = Place.fromJson(jsonPlace);
        places.add(place);
      }
      return QueryResponse(
        results: places,
        numPages: data['data']['last_page'],
        numResults: data['data']['total'],
      );
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<dynamic> fetchPlace(var placeID) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String token = pref.getString("token");
      var response = await Dio().get(Api.place_index + "/$placeID",
          options: Options(
            headers: {"Authorization": "Bearer " + token},
            validateStatus: (status) => true,
          ) // options.headers["Authorization"] = "Bearer " + token;
          );
      var data = response.data;
      Place place;
      for (var jsonPlace in data['data']) {
        place = Place.fromJson(jsonPlace);
      }
      return place;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<dynamic> search(
      {@required String query,
      int page = 1,
      @required SearchFilter filter,
      tagId = ''}) async {
    try {
      var pref = await SharedPreferences.getInstance();
      print("?query=$query&page=$page&${filter.toString()}&tag=${tagId ?? ''}");
      String token = pref.getString("token");
      var response = await Dio().get(
          Api.search_places +
              "?query=$query&page=$page&${filter.toString()}&tag=${tagId ?? ''}",
          options: Options(
            headers: {"Authorization": "Bearer " + token},
            validateStatus: (status) => true,
          ) // options.headers["Authorization"] = "Bearer " + token;

          );
      var data = response.data;
      List<Place> places = [];
      for (var jsonPlace in data['data']['data']) {
        var place = Place.fromJson(jsonPlace);
        places.add(place);
      }
      var arr = [];
      for (var place in places) {
        arr.add(place);
      }
      print("total number of results is:${data['data']['total']}");
      print("total number of pages is:${data['data']['last_page']}");
      return QueryResponse(
          results: places,
          numPages: data['data']['last_page'],
          numResults: data['data']['total'],
          filter: filter);
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<dynamic> autocomplete(String pattern) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String token = pref.getString("token");
      var response = await Dio().get(Api.autocomplete + "?query=$pattern",
          options: Options(
            headers: {"Authorization": "Bearer " + token},
            validateStatus: (status) => true,
          ) // options.headers["Authorization"] = "Bearer " + token;

          );
      var data = response.data;

      List<dynamic> suggestions = [];
      for (var jsonPlace in data['data']) {
        var suggestion;
        if (jsonPlace["model"] == "place") {
          print("its a place");

          suggestion = Place.fromJson(jsonPlace);
        } else if (jsonPlace["model"] == "tag") {
          print("its a tag");

          suggestion = Tag.fromJson(jsonPlace);
        }
        suggestions.add(suggestion);
      }

      return suggestions;
    } catch (e) {
      print(e);
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
    List<Tag> tags,
  }) async {
    try {
      var jsonTags = tags.map((t) => t.toJson()).toList();
      print(jsonTags);
      print("json");
      var pref = await SharedPreferences.getInstance();
      String token = pref.getString("token");
      var formData = FormData.fromMap({
        'data': {
          "title": title,
          "description": description,
          "latitude": latitude,
          "longitude": longitude,
          "municipal_id": municipalID,
          "tags": jsonTags ?? "[]"
        },
        'file[]': await _picturesToMultipartFile(pictures)
      });
      print({
        "title": title,
        "description": description,
        "latitude": latitude,
        "longitude": longitude,
        "municipal_id": municipalID,
        "tags": jsonTags ?? "[]"
      });
      var response = await Dio().post(Api.add_place, data: formData,
          onReceiveProgress: (int count, int total) {
        print('count: $count');
        print('total: $total');
      }, onSendProgress: (int count, int total) {
        print('send count: $count');
        print('send total: $total');
      },
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

  Future<dynamic> update({
    String title,
    String description,
    List<File> pictures,
    int municipalID,
    var placeId,
  }) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String token = pref.getString("token");
      var formData = FormData.fromMap({
        'data': {
          "title": title,
          "description": description,
          "municipal_id": municipalID,
        },
        'file[]':
            pictures != null ? await _picturesToMultipartFile(pictures) : null
      });

      var response = await Dio().post(Api.update_place + "/$placeId",
          data: formData,
          options: Options(
            headers: {
              "Authorization": "Bearer " + token,
              "Accept": "multipart/mixed",
              "Content-Type": "multipart/form-data",
            },
            validateStatus: (status) => true,
          ));
      print(response);
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

  Future<dynamic> fetchWishListPlaces(var page) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String token = pref.getString("token");
      var response = await Dio().get(Api.wishes + "?page=$page",
          options: Options(
            headers: {"Authorization": "Bearer " + token},
            validateStatus: (status) => true,
          ));
      var data = response.data;
      List<Place> places = [];
      for (var jsonPlace in data['data']['data']) {
        var place = Place.fromJson(jsonPlace);
        places.add(place);
      }
      return QueryResponse(
        results: places,
        numPages: data['data']['last_page'],
        numResults: data['data']['total'],
      );
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<dynamic> addToWishList({@required var placeId}) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String token = pref.getString("token");
      var formData = FormData.fromMap({'place_id': placeId});

      var response = await Dio().post(Api.add_to_wishlist,
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
        return true;
      }
      return false;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<dynamic> deleteFromWishList({@required var placeId}) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String token = pref.getString("token");
      var response = await Dio().delete(Api.remove_from_wishlist + "/$placeId",
          options: Options(
            headers: {
              "Authorization": "Bearer " + token,
            },
            validateStatus: (status) => true,
          ));
      var data = response.data;
      print(data);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      throw (e.toString());
    }
  }
}
