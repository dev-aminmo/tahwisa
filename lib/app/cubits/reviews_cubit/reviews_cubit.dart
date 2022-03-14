import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tahwisa/app/repositories/models/Review.dart';
import 'package:tahwisa/app/repositories/models/reviews_response.dart';
import 'package:tahwisa/app/repositories/review_repository.dart';

part 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final ReviewRepository? repository;
  final placeID;

  final _reviews$ = BehaviorSubject<List<Review>>();
  Stream<List<Review>> get reviews => _reviews$;
  final _canLoadMore$ = BehaviorSubject<bool>();
  bool get canLoadMore => _canLoadMore$.value;
  final _isFetching$ = BehaviorSubject<bool>();
  bool get isFetching => _isFetching$.value;
  final _reviews = <Review>[];

  int _page = 1;

  @override
  Future<void> close() {
    _canLoadMore$.close();
    _isFetching$.close();
    _reviews$.close();
    return super.close();
  }

  ReviewsCubit({required this.repository, required this.placeID})
      : super(ReviewsLoading()) {
    _canLoadMore$.add(true);
    _isFetching$.add(false);
    fetchReviews();
  }
  void fetchReviews() async {
    print("Fetching places");
    try {
      _isFetching$.add(true);
      ReviewsResponse response =
          await (repository!.fetchReviews(placeId: placeID, page: _page)
              as Future<ReviewsResponse>);

      _reviews.addAll(response.reviews);
      _reviews$.add(_reviews);
      if (response.numPages! <= _page) {
        _canLoadMore$.add(false);
      } else {
        _canLoadMore$.add(true);
      }
      _isFetching$.add(false);
      _page++;
      if (_page <= 2) emit(ReviewsSuccess(response.reviews));
    } catch (e) {
      _isFetching$.add(false);
      emit(ReviewsError());
    }
  }
}
