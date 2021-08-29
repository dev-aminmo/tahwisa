import 'package:flutter/material.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:tahwisa/repositories/models/place.dart';
import 'package:tahwisa/style/my_colors.dart';

Widget buildRating(double x) {
  return RatingBar.readOnly(
    size: 24,
    filledIcon: Icons.star,
    emptyIcon: Icons.star_border,
    halfFilledIcon: Icons.star_half,
    emptyColor: MyColors.darkBlue,
    filledColor: MyColors.darkBlue,
    halfFilledColor: MyColors.darkBlue,
    initialRating: x,
    isHalfAllowed: true,
  );
}

class PlaceCard extends StatelessWidget {
  const PlaceCard({Key key, @required this.place, this.callback, this.width})
      : super(key: key);

  final VoidCallback callback;
  final Place place;
  final width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: width * 0.025, right: width * 0.025, top: 8, bottom: 16),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: callback,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            color: Colors.grey.shade400,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                offset: const Offset(4, 4),
                blurRadius: 16,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 2,
                      child: Image.network(
                        /* place.pictures[0].replaceFirstMapped(
                            "image/upload/",
                            (match) =>
                                "image/upload/w_${(width).round()},f_auto/"),
                        */
                        "https://images.unsplash.com/photo-1517712604573-5cd32ea201a9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8dW5rbm93bnx8fHx8fDE2MzAxNzUxNTU&ixlib=rb-1.2.1&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1080",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      color: const Color(0xFFFFFFFF),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, top: 8, bottom: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(right: 16),
                                      child: Text(
                                        " ${place.id} " + place.title,
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          Icons.location_on,
                                          size: 14,
                                          color: Color(0xff54D3C2),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Chlef, Chettia',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey
                                                    .withOpacity(0.8)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        children: <Widget>[
                                          buildRating(3.5),
                                          /*RatingBar(
                                                    initialRating:
                                                    hotelData!.rating,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    itemSize: 24,
                                                    ratingWidget: RatingWidget(
                                                      full: Icon(
                                                        Icons.star_rate_rounded,
                                                        color: HotelAppTheme
                                                            .buildLightTheme()
                                                            .primaryColor,
                                                      ),
                                                      half: Icon(
                                                        Icons.star_half_rounded,
                                                        color: HotelAppTheme
                                                            .buildLightTheme()
                                                            .primaryColor,
                                                      ),
                                                      empty: Icon(
                                                        Icons
                                                            .star_border_rounded,
                                                        color: HotelAppTheme
                                                            .buildLightTheme()
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    itemPadding:
                                                    EdgeInsets.zero,
                                                    onRatingUpdate: (rating) {
                                                      print(rating);
                                                    },
                                                  ),*/
                                          Text(
                                            ' 62 Reviews',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey
                                                    .withOpacity(0.8)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                            //Icons.favorite_outlined,
                            Icons.favorite_border,
                            color: MyColors.lightGreen),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
