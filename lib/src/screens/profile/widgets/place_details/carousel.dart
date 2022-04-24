import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tahwisa/src/repositories/models/place.dart';
import 'package:tahwisa/src/style/my_colors.dart';

import 'full_screen_image.dart';

class Carousel extends StatefulWidget {
  final place;
  final heroAnimationTag;

  Carousel({required this.place, required this.heroAnimationTag});

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  var currentPosition = 0;

  Place? place;

  @override
  void initState() {
    super.initState();
    place = widget.place;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        /*
              buildCarouselSlider(width, widget.heroAnimationTag),
              buildCarouselDots(),*/
        Container(
          color: Colors.black,
          child: CarouselSlider.builder(
              options: CarouselOptions(
                  scrollPhysics: const BouncingScrollPhysics(),
                  disableCenter: false,
                  enableInfiniteScroll: false,
                  aspectRatio: 1.1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentPosition = index;
                    });
                  },
                  viewportFraction: 1),
              itemCount: place!.pictures!.length,
              itemBuilder: (context, index, realIndex) {
                return GestureDetector(
                    onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullScreenImage(
                                      child: PhotoView(
                                    imageProvider:
                                        NetworkImage(place!.pictures![index]!),
                                  ))),
                        ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Hero(
                        tag:
                            'place_tag_${place!.id}_${widget.heroAnimationTag}',
                        child: Image.network(
                          place!.pictures![index]!.replaceFirstMapped(
                              "image/upload/",
                              (match) =>
                                  "image/upload/w_${(width).round()},f_auto/"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ));
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: place!.pictures!.map((picture) {
            int index = place!.pictures!.indexOf(picture);
            return Container(
              width: 12.0,
              height: 12.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentPosition == index
                    ? MyColors.darkBlue
                    : MyColors.darkBlue.withOpacity(0.4),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
