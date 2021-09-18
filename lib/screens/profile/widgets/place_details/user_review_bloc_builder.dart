import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/cubits/user_review_cubit/user_review_cubit.dart';

import 'add_review.dart';

class UserReviewBlocBuilder extends StatelessWidget {
  const UserReviewBlocBuilder({
    Key key,
    @required UserReviewCubit userReviewCubit,
  })  : _userReviewCubit = userReviewCubit,
        super(key: key);

  final UserReviewCubit _userReviewCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserReviewCubit, UserReviewState>(
      cubit: _userReviewCubit,
      builder: (context, state) {
        if (state is UserReviewEmpty) {
          return AddReview();
        }
        if (state is UserReviewLoaded) {
          return Text("here is  your review ${state.review.vote}");
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
