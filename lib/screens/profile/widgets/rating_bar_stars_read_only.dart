import 'package:flutter/material.dart';

class RatingBarStarsReadOnly extends StatelessWidget {
  const RatingBarStarsReadOnly(
      {Key? key, required this.reviewsAverage, this.iconSize = 24.0})
      : super(key: key);

  final reviewsAverage;
  final iconSize;

  @override
  Widget build(BuildContext context) {
    /*   return RatingBar.readOnly(
      size: iconSize,
      filledIcon: Icons.star,
      emptyIcon: Icons.star_border,
      halfFilledIcon: Icons.star_half,
      emptyColor: MyColors.darkBlue,
      filledColor: MyColors.darkBlue,
      halfFilledColor: MyColors.darkBlue,
      initialRating: reviewsAverage + 0.0,
      maxRating: 5,
      isHalfAllowed: true,
    );*/
    return Container();
  }
}
