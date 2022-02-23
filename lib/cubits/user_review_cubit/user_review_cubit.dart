import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/repositories/models/Review.dart';
import 'package:tahwisa/repositories/review_repository.dart';

part 'user_review_state.dart';

class UserReviewCubit extends Cubit<UserReviewState> {
  final ReviewRepository? repository;
  final placeID;

  UserReviewCubit({required this.repository, required this.placeID})
      : super(UserReviewLoading()) {
    fetchUserReview();
  }
  void fetchUserReview() async {
    emit(UserReviewLoading());

    Review? review =
        await (repository!.fetchUserReview(placeID) as Future<Review?>);
    if (review != null) {
      emit(UserReviewLoaded(review));
    } else {
      emit(UserReviewEmpty());
    }
  }

  Future<void> postReview({required var rating, var comment}) async {
    emit(UserReviewPostLoading());

    try {
      var response = await repository!
          .postReview(rating: rating, comment: comment, placeId: placeID);
      print("response");
      print((response) ? true : false);
      print(response);
      if (response) {
        print("emitted");
        emit(UserReviewPostSuccess());
      } else {
        emit(UserReviewError());
      }
    } catch (e) {
      emit(UserReviewError());
    }
  }

  void deleteReview({required var reviewID}) async {
    emit(UserReviewLoading());
    try {
      var response = await repository!.deleteUserReview(reviewID);
      if (response) {
        emit(UserReviewEmpty());
      } else {
        emit(UserReviewError());
      }
    } catch (e) {
      emit(UserReviewError());
    }
  }
}
