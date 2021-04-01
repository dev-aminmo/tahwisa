import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'models/place.dart';

class PlaceRepository {
  Future<dynamic> fetchPlaces() async {
    try {
      var pref=  await SharedPreferences.getInstance();
      String token =pref. getString("token");
      var response = await Dio().get(Api.all_places,
          options: Options(headers: {
            "Authorization": "Bearer " +
          token
          }) // options.headers["Authorization"] = "Bearer " + token;
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
}
