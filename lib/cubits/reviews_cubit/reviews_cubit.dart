import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tahwisa/repositories/models/Review.dart';
import 'package:tahwisa/repositories/models/reviews_response.dart';
import 'package:tahwisa/repositories/review_repository.dart';

part 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final ReviewRepository repository;
  final placeID;
  final _canLoadMore = BehaviorSubject<bool>();

  bool get canLoadMore => _canLoadMore.value;
  int _page = 1;

  @override
  Future<Function> close() {
    _canLoadMore.close();
    super.close();
  }

  ReviewsCubit({@required this.repository, @required this.placeID})
      : super(ReviewsLoading()) {
    _canLoadMore.add(true);
    fetchReviews();
  }
  void fetchReviews() async {
    emit(ReviewsLoading());
    try {
      ReviewsResponse response =
          await repository.fetchReviews(placeId: placeID);
      if (response.numPages <= _page) {
        _canLoadMore.add(false);
      } else {
        _canLoadMore.add(true);
      }
      _page++;
      emit(ReviewsSuccess(response.reviews));
    } catch (e) {
      emit(ReviewsError());
    }
  }
}
