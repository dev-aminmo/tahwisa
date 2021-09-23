import 'package:flutter/material.dart';
import 'package:tahwisa/repositories/models/Review.dart';
import 'package:tahwisa/style/my_colors.dart';

import '../rating_bar_stars_read_only.dart';

class ReviewItem extends StatelessWidget {
  final Review review;

  ReviewItem(this.review);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CircleAvatar(
                minRadius: 22,
                backgroundColor: MyColors.gray,
                backgroundImage: NetworkImage(
                  review.user.profilePicture.replaceFirstMapped(
                      "image/upload/", (match) => "image/upload/w_150,f_auto/"),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      review.user.name + "${review.id}",
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
                        reviewsAverage: review.rating,
                        iconSize: 14.0,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        review.createdAt,
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
                review.comment ?? '',
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
    );
  }
}
