import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/cubits/user_review_cubit/user_review_cubit.dart';
import 'package:tahwisa/style/my_colors.dart';

import '../rating_bar_stars_read_only.dart';
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
              color: Colors.transparent,
              elevation: 0,
              child: Container(
                padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: Text(
                          "Your Review",
                          textAlign: TextAlign.left,
                          softWrap: true,
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              color: MyColors.darkBlue),
                        ),
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              minRadius: 22,
                              backgroundColor: MyColors.gray,
                              backgroundImage: NetworkImage(
                                state.review.user.profilePicture
                                    .replaceFirstMapped(
                                        "image/upload/",
                                        (match) =>
                                            "image/upload/w_150,f_auto/"),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    state.review.user.name,
                                    textAlign: TextAlign.left,
                                    softWrap: true,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                        color: MyColors.darkBlue),
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  children: [
                                    RatingBarStarsReadOnly(
                                      reviewsAverage: state.review.rating,
                                      iconSize: 14.0,
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      state.review.createdAt,
                                      textAlign: TextAlign.left,
                                      softWrap: true,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14,
                                          color: MyColors.darkBlue),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.more_vert_outlined,
                                color: MyColors.gray,
                              ),
                              onPressed: () {},
                            )
                          ]),
                      const SizedBox(
                        height: 8,
                      ),
                      Flexible(
                        child: Text(
                          state.review.comment,
                          textAlign: TextAlign.left,
                          softWrap: true,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: MyColors.gray),
                        ),
                      ),
                    ]),
              ),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
