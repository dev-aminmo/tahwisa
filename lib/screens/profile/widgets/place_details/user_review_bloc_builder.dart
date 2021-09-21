import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/cubits/user_review_cubit/user_review_cubit.dart';
import 'package:tahwisa/style/my_colors.dart';

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
    return BlocProvider.value(
      value: _userReviewCubit,
      child: BlocConsumer<UserReviewCubit, UserReviewState>(
        //cubit: context.read<UserReviewCubit>(),
        listener: (context, state) {
          if (state is UserReviewPostSuccess) {
            _userReviewCubit.fetchUserReview();
          }
        },
        builder: (context, state) {
          if (state is UserReviewEmpty) {
            return AddReview();
          }
          if (state is UserReviewLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is UserReviewLoaded) {
            return Card(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Review",
                      textAlign: TextAlign.left,
                      softWrap: true,
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: MyColors.darkBlue),
                    ),
                  ]),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
