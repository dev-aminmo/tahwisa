import 'package:flutter/material.dart';
import 'package:tahwisa/repositories/models/place.dart';
import 'package:tahwisa/style/my_colors.dart';

import 'rating_bar_stars_read_only.dart';

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
        onTap: () {
          Navigator.pushNamed(
            context,
            '/place_details',
            arguments: place,
          );
        },
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
                        child: Hero(
                          tag: 'place_tag${place.id}',
                          child: Image.network(
                            place.pictures[0].replaceFirstMapped(
                                "image/upload/",
                                (match) =>
                                    "image/upload/w_${(width).round()},f_auto/"),
                            fit: BoxFit.cover,
                          ),
                        )),
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
                                        place.title,
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
                                            '${place.state}, ${place.municipal}',
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
                                          RatingBarStarsReadOnly(
                                              reviewsAverage:
                                                  place.reviewsAverage),
                                          Text(
                                            ' ${place.reviewsCount} Reviews',
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
                          (place.wished)
                              ? Icons.favorite_outlined
                              : Icons.favorite_border,
                          color: MyColors.lightGreen,
                        ),
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
