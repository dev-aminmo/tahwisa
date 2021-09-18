import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tahwisa/repositories/models/Review.dart';

import 'api/api_endpoints.dart';

class ReviewRepository {
  /// Mocks fetching Tags from network API with delay of 500ms.

  Future<dynamic> fetchReviews({
    @required var placeId,
    int page = 1,
  }) async {
    var pref = await SharedPreferences.getInstance();
    String token = pref.getString("token");
    var response = await Dio().get(Api.reviews + "/$placeId",
        options: Options(
          headers: {"Authorization": "Bearer " + token},
        ));
    var data = response.data;
    List<Review> reviews = [];

    for (var jsonReview in data) {
      var tag = Review.fromJson(jsonReview);
      reviews.add(tag);
    }

    return "";
  }

  Future<dynamic> fetchUserReview(var placeId) async {
    var pref = await SharedPreferences.getInstance();
    String token = pref.getString("token");
    print(Api.user_review + "/$placeId");
    var response = await Dio().get(Api.user_review + "/$placeId",
        options: Options(
          headers: {"Authorization": "Bearer " + token},
        ));
    var data = await response.data;
    Review review;
    if ((response.statusCode == 200) && data != null) {
      if (data['data'] != null) review = Review.fromJson(data['data']);
    }

    print(data);
    print(review);

    return review;
  }
}
