part of 'user_review_cubit.dart';

@immutable
abstract class UserReviewState extends Equatable {
  const UserReviewState();
  @override
  List<Object> get props => [];
}

class UserReviewInitial extends UserReviewState {}

class UserReviewLoading extends UserReviewState {}

class UserReviewPostLoading extends UserReviewState {}

class UserReviewEmpty extends UserReviewState {}

class UserReviewError extends UserReviewState {}

class UserReviewPostSuccess extends UserReviewState {}

class UserReviewLoaded extends UserReviewState {
  UserReviewLoaded(this.review);
  final Review review;
  @override
  List<Object> get props => [review];
}
