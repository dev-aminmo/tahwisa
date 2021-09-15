import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tahwisa/repositories/models/place.dart';
import 'package:tahwisa/style/my_colors.dart';

class PlaceDetailsScreen extends StatefulWidget {
  static const String routeName = '/place_details';

  static Route route({@required Place place}) {
    return MaterialPageRoute(
      builder: (_) => PlaceDetailsScreen(place: place),
      settings: RouteSettings(name: routeName),
    );
  }

  final Place place;

  const PlaceDetailsScreen({
    @required this.place,
  });

  @override
  _PlaceDetailsScreenState createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  var currentPosition = 0;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: MyColors.white,
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CarouselSlider.builder(
                options: CarouselOptions(
                    scrollPhysics: BouncingScrollPhysics(),
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 2),
                    disableCenter: false,
                    enableInfiniteScroll: false,
                    aspectRatio: 1.1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentPosition = index;
                      });
                    },
                    viewportFraction: 1),
                itemCount: widget.place.pictures.length,
                itemBuilder: (context, index, realIndex) {
                  return SizedBox(
                    width: double.infinity,
                    child: Image.network(
                      widget.place.pictures[index].replaceFirstMapped(
                          "image/upload/",
                          (match) =>
                              "image/upload/w_${(width).round()},f_auto/"),
                      fit: BoxFit.cover,
                    ),
                  );
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.place.pictures.map((picture) {
                int index = widget.place.pictures.indexOf(picture);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentPosition == index
                        ? Color.fromRGBO(0, 0, 0, 0.9)
                        : Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                );
              }).toList(),
            ),
          ]),
        ));
  }
}
