import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/cubits/reviews_cubit/reviews_cubit.dart';

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
  ReviewsCubit _reviewsCubit;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _reviewsCubit = context.read<ReviewsCubit>();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _reviewsCubit.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewsCubit, ReviewsState>(
      cubit: _reviewsCubit,
      builder: (context, state) {
        if (state is ReviewsLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is ReviewsSuccess) {
          var length = state.reviews.length;
          if (length > 5) {
            return ListView.separated(
                separatorBuilder: (_, __) {
                  return Divider(
                    indent: 32,
                    endIndent: 32,
                    height: 16,
                  );
                },
                padding: EdgeInsets.all(
                  16,
                ),
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  if (index == 2) {
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
                        child: Text("See all reviews"),
                      ),
                    );
                  }
                  return ReviewItem(state.reviews[index]);
                });
          } else {
            return ListView.separated(
                separatorBuilder: (_, __) {
                  return Divider(
                    indent: 32,
                    endIndent: 32,
                    height: 16,
                  );
                },
                padding: EdgeInsets.all(
                  16,
                ),
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: state.reviews.length,
                itemBuilder: (context, index) =>
                    ReviewItem(state.reviews[index]));
          }
        } else {
          return SizedBox();
        }
      },
    );
  }
}
