import 'package:meta/meta.dart';

import 'Review.dart';

class ReviewsResponse {
  final List<Review> reviews;
  final int numPages;
  final int numResults;

  const ReviewsResponse({
    @required this.reviews,
    @required this.numPages,
    @required this.numResults,
  });
}
