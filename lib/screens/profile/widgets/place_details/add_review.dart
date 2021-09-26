import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:tahwisa/cubits/user_review_cubit/user_review_cubit.dart';
import 'package:tahwisa/style/my_colors.dart';

class AddReview extends StatelessWidget {
  const AddReview({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Rate this place",
          textAlign: TextAlign.left,
          softWrap: true,
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              color: MyColors.darkBlue),
        ),
        Text(
          "Tell others what you think",
          textAlign: TextAlign.left,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: MyColors.gray.withOpacity(0.7)),
        ),
        const SizedBox(height: 22),
        Hero(
          tag: "rate",
          child: RatingBar(
            onRatingChanged: (rating) {
              Navigator.pushNamed(
                context,
                '/rate_place',
                arguments: {
                  'initialRate': rating,
                  'userReviewCubit': context.read<UserReviewCubit>()
                },
              );
            },
            size: 48,
            filledIcon: Icons.star,
            emptyIcon: Icons.star_border,
            halfFilledIcon: Icons.star_half,
            emptyColor: MyColors.darkBlue,
            filledColor: MyColors.darkBlue,
            halfFilledColor: MyColors.darkBlue,
            initialRating: 0.0,
            maxRating: 5,
            isHalfAllowed: true,
          ),
        ),
      ],
    );
  }
}
