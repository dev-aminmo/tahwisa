part of 'reviews_cubit.dart';

@immutable
abstract class ReviewsState extends Equatable {
  const ReviewsState();
  @override
  List<Object> get props => [];
}

class ReviewsInitial extends ReviewsState {}

class ReviewsLoading extends ReviewsState {}

class ReviewsSuccess extends ReviewsState {
  ReviewsSuccess(this.reviews);
  final List<Review> reviews;
  @override
  List<Object> get props => [reviews];
}

class ReviewsError extends ReviewsState {}
