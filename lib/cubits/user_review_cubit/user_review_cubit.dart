import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/repositories/models/Review.dart';

part 'user_review_state.dart';

class UserReviewCubit extends Cubit<UserReviewState> {
  UserReviewCubit() : super(UserReviewInitial());
}
