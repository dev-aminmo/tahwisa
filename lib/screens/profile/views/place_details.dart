import 'package:flutter/material.dart';
import 'package:tahwisa/repositories/models/place.dart';

class PlaceDetailsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom:
                      Radius.elliptical(MediaQuery.of(context).size.width, 50),
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    place.pictures[0],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
