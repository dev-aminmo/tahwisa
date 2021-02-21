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
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.025, vertical: height * 0.03),
      child: Stack(
        children: [
          Container(
              height: height * 0.4,
              decoration: BoxDecoration(
                  //TODO add shadow
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25),
                  )),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                margin: EdgeInsets.only(top: height * 0.3),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("  - jardin d'essai"),
                            SizedBox(height: height * 0.005),
                            Row(children: [
                              Icon(Icons.location_on, color: MyColors.darkBlue),
                              Text('Algiers, Algeria'),
                            ]),
                          ]),
                      IconButton(
                        icon: Icon(Icons.favorite, color: MyColors.darkBlue),
                        onPressed: () {},
                      )
                    ]),
              )),
          Stack(
            children: [
              Transform.translate(
                offset: Offset(0, -5),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
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
  /*Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: height * 0.4,
            decoration: BoxDecoration(
                //TODO add shadow
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                  topRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                )),
            margin: EdgeInsets.symmetric(
                horizontal: width * 0.025, vertical: height * 0.05),
            child: Column(
              children: [
                Stack(
                  children: [
                    Transform.translate(
                      offset: Offset(0, -5),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
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
                // SizedBox(height: height * 0.005),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                            //mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("  - jardin d'essai"),
                              SizedBox(height: height * 0.005),
                              Row(children: [
                                Icon(Icons.location_on,
                                    color: MyColors.darkBlue),
                                Text('Algiers, Algeria'),
                              ]),
                            ]),
                        IconButton(
                          icon: Icon(Icons.favorite, color: MyColors.darkBlue),
                          onPressed: () {},
                        )
                      ]),
                ),
              ],
            )),
      ],
    );
  }*/

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
