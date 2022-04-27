import 'package:dio/dio.dart';
import 'package:tahwisa/src/repositories/models/Review.dart';
import 'package:tahwisa/src/utilities/dio_http_client.dart';

import 'api/api_endpoints.dart';
import 'models/reviews_response.dart';

class ReviewRepository {
  /// Mocks fetching Tags from network API with delay of 500ms.

  Future<dynamic> fetchReviews({
    required var placeId,
    int page = 1,
  }) async {
    var response =
        await DioHttpClient.getWithHeader(Api.reviews + "/$placeId?page=$page");
    var data = response.data;
    List<Review> reviews = [];
    if (response.statusCode == 200) {
      for (var jsonReview in data['data']['reviews']) {
        var review = Review.fromJson(jsonReview);
        reviews.add(review);
      }
      return ReviewsResponse(
        reviews: reviews,
        numPages: data['data']['total_pages'],
        numResults: data['data']['total'],
      );
    }
    return false;
  }

  Future<Review?> fetchUserReview(var placeId) async {
    var response =
        await DioHttpClient.getWithHeader(Api.userReview + "/$placeId");
    var data = await response.data;
    Review? review;
    if ((response.statusCode == 200) && data != null) {
      if (data['data'] != null) review = Review.fromJson(data['data']);
    }
    return review;
  }

  Future<dynamic> deleteUserReview(var reviewID) async {
    var response = await DioHttpClient.deleteWithHeader(
        Api.deleteUserReview + "/$reviewID");
    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }

  Future<dynamic> postReview({
    required double? rating,
    String? comment,
    int? placeId,
  }) async {
    try {
      var formData = FormData.fromMap(
          {"vote": rating, "comment": comment, "place_id": placeId});
      var response =
          await DioHttpClient.postWithHeader(Api.postReview, body: formData);
      if (response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      throw (e.toString());
    }
  }
}
