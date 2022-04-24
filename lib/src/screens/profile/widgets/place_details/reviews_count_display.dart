import 'package:flutter/material.dart';
import 'package:tahwisa/src/style/my_colors.dart';

import 'rating_bar_read_only.dart';

class ReviewsCountDisplay extends StatelessWidget {
  final place;

  ReviewsCountDisplay({required this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(place.reviewsAverage.toStringAsFixed(1),
              style: TextStyle(
                  height: 0.7,
                  textBaseline: TextBaseline.alphabetic,
                  fontWeight: FontWeight.w600,
                  fontSize: 48,
                  color: MyColors.darkBlue)),
          const SizedBox(width: 8),
          RatingBarReadOnlyRow(place: place)
        ],
      ),
    );
  }
}
