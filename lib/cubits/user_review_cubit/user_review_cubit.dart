import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/repositories/models/Review.dart';
import 'package:tahwisa/repositories/review_repository.dart';

part 'user_review_state.dart';

class UserReviewCubit extends Cubit<UserReviewState> {
  final ReviewRepository repository;
  final placeID;

  UserReviewCubit({@required this.repository, @required this.placeID})
      : super(UserReviewLoading()) {
    fetchUserReview(placeID);
  }
  void fetchUserReview(var placeID) async {
    emit(UserReviewLoading());

    Review review = await repository.fetchUserReview(placeID);
    if (review != null) {
      emit(UserReviewLoaded(review));
    } else {
      emit(UserReviewEmpty());
    }
  }

  void updateReview(var reviewID) {}
  void deleteReview(var reviewID) {}
}
