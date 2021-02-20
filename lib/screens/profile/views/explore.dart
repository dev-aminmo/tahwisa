import 'package:flutter/material.dart';
import 'package:tahwisa/screens/profile/widgets/place_card.dart';
import 'package:tahwisa/style/my_colors.dart';

class Explore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return ListView.builder(
      itemCount: 20,
      itemBuilder: (ctx, position) {
        return PlaceCard(height: height, width: width);
      },
    );
  }
}
