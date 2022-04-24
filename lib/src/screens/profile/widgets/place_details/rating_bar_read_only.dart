import 'package:flutter/material.dart';
import 'package:tahwisa/src/repositories/models/place.dart';

import '../rating_bar_stars_read_only.dart';

class RatingBarReadOnlyRow extends StatelessWidget {
  const RatingBarReadOnlyRow({
    Key? key,
    required this.place,
  }) : super(key: key);

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RatingBarStarsReadOnly(
          reviewsAverage: place.reviewsAverage,
          iconSize: 26.0,
        ),
        Transform.translate(
          offset: Offset(0, 2),
          child: Text(
            ' ( ${place.reviewsCount} Reviews ).',
            style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8)),
          ),
        ),
      ],
    );
  }
}
