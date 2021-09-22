import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/repositories/models/Review.dart';
import 'package:tahwisa/repositories/review_repository.dart';

part 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final ReviewRepository repository;
  final placeID;

  ReviewsCubit({@required this.repository, @required this.placeID})
      : super(ReviewsLoading()) {
    fetchUserReview();
  }
  void fetchUserReview() async {
    emit(ReviewsLoading());
    try {
      List<Review> reviews = await repository.fetchReviews(placeId: placeID);
      emit(ReviewsSuccess(reviews));
    } catch (e) {
      emit(ReviewsError());
    }
  }
}
