import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/app/cubits/reviews_cubit/reviews_cubit.dart';
import 'package:tahwisa/app/style/my_colors.dart';

import 'review_item.dart';

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
  ReviewsCubit? _reviewsCubit;

  @override
  void initState() {
    super.initState();
    _reviewsCubit = context.read<ReviewsCubit>();
  }

  @override
  void dispose() {
    _reviewsCubit!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewsCubit, ReviewsState>(
      bloc: _reviewsCubit,
      builder: (context, state) {
        if (state is ReviewsLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is ReviewsSuccess) {
          print("reviews length ${state.reviews.length}");
          return ListView.separated(
              separatorBuilder: (_, index) {
                if (state.reviews.length > 5 && index == 1) {
                  return SizedBox();
                }
                return Divider(
                  indent: 32,
                  endIndent: 32,
                  height: 16,
                );
              },
              padding: EdgeInsets.symmetric(
                vertical: 16,
              ),
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: state.reviews.length > 5 ? 3 : state.reviews.length,
              itemBuilder: (context, index) {
                if (state.reviews.length > 5 && index == 2) {
                  return Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/reviews',
                            arguments: {
                              'reviewsCubit': _reviewsCubit,
                            },
                          );
                        },
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(50, 30),
                            alignment: Alignment.centerLeft),
                        child: Text(
                          "See all reviews",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              color: MyColors.lightGreen),
                        ),
                      ));
                }
                return ReviewItem(state.reviews[index]);
              });
        } else {
          return SizedBox();
        }
      },
    );
  }
}
