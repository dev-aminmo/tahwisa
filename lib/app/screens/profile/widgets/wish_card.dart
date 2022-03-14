import 'package:flutter/material.dart';
import 'package:tahwisa/app/style/my_colors.dart';

class WishCard extends StatelessWidget {
  const WishCard({
    Key? key,
    required this.height,
    required this.width,
    required this.index,
  }) : super(key: key);

  final double height;
  final double width;
  final int index;

  @override
  /*Widget build(BuildContext context) {
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
          horizontal: width * 0.025, vertical: height * 0.03),
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
                              app.style: TextStyle(
                                  color: MyColors.lightGreen, fontSize: 16),
                            ),
                            SizedBox(height: height * 0.008),
                            Row(children: [
                              Icon(Icons.location_on, color: MyColors.darkBlue),
                              Text(
                                'Algiers, Algeria',
                                app.style: TextStyle(
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
  }*/
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: width * 0.025, vertical: height * 0.012),
        child: Stack(
            //alignment: Alignment.center,
            children: [
              ClipRRect(
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
              Positioned(
                top: 20,
                left: 20,
                child: Row(children: [
                  Icon(Icons.location_on, color: MyColors.white),
                  Text(
                    'Algiers, Algeria',
                    style: TextStyle(color: MyColors.white, fontSize: 16),
                  ),
                ]),
              ),
              Positioned(
                  bottom: 20,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "- jardin d'essai",
                        style: TextStyle(color: MyColors.white, fontSize: 16),
                      ),
                      SizedBox(height: height * 0.003),
                      buildRating(3.2),
                    ],
                  )),
              Positioned(
                top: 20,
                right: 20,
                child: Stack(alignment: Alignment.center, children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: width * 0.15,
                      width: width * 0.15,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                          vertical: width * 0.02, horizontal: width * 0.02),
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(52))),
                      child: Icon(Icons.favorite,
                          color: MyColors.white, size: width * 0.1),
                    ),
                  ),
                ]),
              ),
            ]));
  }

  Widget buildRating(double x) {
    return /*RatingBar.readOnly(
      filledIcon: Icons.star,
      emptyIcon: Icons.star_border,
      halfFilledIcon: Icons.star_half,
      emptyColor: MyColors.white,
      filledColor: MyColors.white,
      halfFilledColor: MyColors.white,
      initialRating: x,
      isHalfAllowed: true,
    );*/
        Container();
  }
}
