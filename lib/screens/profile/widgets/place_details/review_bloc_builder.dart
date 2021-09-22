import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/cubits/reviews_cubit/reviews_cubit.dart';
import 'package:tahwisa/style/my_colors.dart';

import '../rating_bar_stars_read_only.dart';

class ReviewBlocBuilder extends StatefulWidget {
  // const ReviewBlocBuilder({
  //   Key key,
  //   @required ReviewsCubit reviewsCubit,
  // })  : _reviewsCubit = reviewsCubit,
  //       super(key: key);
  //
  // final ReviewsCubit _reviewsCubit;

  @override
  _UserReviewBlocBuilderState createState() => _UserReviewBlocBuilderState();
}

class _UserReviewBlocBuilderState extends State<ReviewBlocBuilder> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewsCubit, ReviewsState>(
      cubit: context.read<ReviewsCubit>(),
      builder: (context, state) {
        if (state is ReviewsLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is ReviewsSuccess) {
          return ListView.separated(
            separatorBuilder: (_, __) {
              return Divider(
                indent: 32,
                endIndent: 32,
                height: 16,
              );
            },
            padding: EdgeInsets.only(top: 16),
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: state.reviews.length,
            itemBuilder: (context, index) => Card(
              color: Colors.transparent,
              elevation: 0,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            minRadius: 22,
                            backgroundColor: MyColors.gray,
                            backgroundImage: NetworkImage(
                              state.reviews[index].user.profilePicture
                                  .replaceFirstMapped("image/upload/",
                                      (match) => "image/upload/w_150,f_auto/"),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  state.reviews[index].user.name,
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
                                    reviewsAverage: state.reviews[index].rating,
                                    iconSize: 14.0,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    state.reviews[index].createdAt,
                                    textAlign: TextAlign.left,
                                    softWrap: true,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: MyColors.gray),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Spacer(),
                        ]),
                    const SizedBox(
                      height: 8,
                    ),
                    Flexible(
                      child: Text(
                        state.reviews[index].comment ?? '',
                        textAlign: TextAlign.left,
                        softWrap: true,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: MyColors.gray),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ]),
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  @override
  void dispose() {
    //  widget._reviewsCubit.close();
    super.dispose();
  }
}
