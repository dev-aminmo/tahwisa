part of 'reviews_cubit.dart';

@immutable
abstract class ReviewsState {}

class ReviewsInitial extends ReviewsState {}

class ReviewsLoading extends ReviewsState {}

class ReviewsSuccess extends ReviewsState {
  ReviewsSuccess(this.reviews);
  final List<Review> reviews;
}

class ReviewsError extends ReviewsState {}
