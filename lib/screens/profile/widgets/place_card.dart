import 'package:flutter/material.dart';
import 'package:tahwisa/style/my_colors.dart';
import 'package:rating_bar/rating_bar.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard({
    Key key,
    @required this.height,
    @required this.width,
    @required this.index,
  }) : super(key: key);

  final double height;
  final double width;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(-3, -3),
                spreadRadius: 2)
          ]),
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.025, vertical: height * 0.018),
      child: Stack(
        children: [
          Container(
              height: height * 0.4,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                margin: EdgeInsets.only(top: height * 0.3),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "  - jardin d'essai",
                              style: TextStyle(
                                  color: MyColors.lightGreen, fontSize: 16),
                            ),
                            SizedBox(height: height * 0.008),
                            Row(children: [
                              Icon(Icons.location_on, color: MyColors.darkBlue),
                              Text(
                                'Algiers, Algeria',
                                style: TextStyle(
                                    color: MyColors.darkBlue, fontSize: 16),
                              ),
                            ]),
                          ]),
                      IconButton(
                        icon: Icon(Icons.favorite,
                            color: MyColors.darkBlue, size: 32),
                        onPressed: () {},
                      )
                    ]),
              )),
          Stack(
            children: [
              Transform.translate(
                offset: Offset(0, -5),
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25)),
                    child: Stack(
                      children: [
                        Container(
                          color: Colors.grey.shade400,
                          width: width * 0.96,
                          height: height * 0.3,
                        ),
                        Image.network(
                          "https://source.unsplash.com/random/${(width * 0.96).round()}x${(height * 0.3).round()}?nature?sig=$index",
                          height: height * 0.3,
                          fit: BoxFit.cover,
                          width: width * 0.97,
                        ),
                      ],
                    )),
              ),
              Positioned(bottom: 20, left: 20, child: buildRating(3.2))
            ],
          ),
        ],
      ),
    );
  }

  Widget buildRating(double x) {
    return RatingBar.readOnly(
      filledIcon: Icons.star,
      emptyIcon: Icons.star_border,
      halfFilledIcon: Icons.star_half,
      emptyColor: MyColors.white,
      filledColor: MyColors.white,
      halfFilledColor: MyColors.white,
      initialRating: x,
      isHalfAllowed: true,
    );
  }
}
