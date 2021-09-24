import 'package:flutter/material.dart';
import 'package:tahwisa/repositories/models/place.dart';
import 'package:tahwisa/screens/profile/views/LocationDisplayScreen.dart';
import 'package:tahwisa/style/my_colors.dart';

class LocationRow extends StatelessWidget {
  const LocationRow({
    Key key,
    @required this.place,
  }) : super(key: key);

  final Place place;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => LocationDisplayScreen(
                      latitude: place.latitude,
                      longitude: place.longitude,
                      title: place.title,
                    )));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.translate(
            offset: Offset(-3, -4),
            child: Icon(
              Icons.location_on,
              size: 22,
              color: Color(0xff54D3C2),
            ),
          ),
          Flexible(
            child: Text('${place.state}, ${place.municipal}',
                softWrap: true,
                style: TextStyle(
                  shadows: [
                    Shadow(color: MyColors.darkBlue, offset: Offset(0, -5))
                  ],
                  color: Colors.transparent,
                  decoration: TextDecoration.underline,
                  decorationColor: MyColors.darkBlue,
                  fontSize: 18,
                )
                //color: MyColors.darkBlue),
                ),
          ),
        ],
      ),
    );
  }
}
