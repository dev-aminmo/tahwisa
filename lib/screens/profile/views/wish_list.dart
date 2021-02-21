import 'package:flutter/material.dart';
import 'package:tahwisa/screens/profile/widgets/wish_card.dart';

class WishList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return ListView.builder(
      itemCount: 20,
      itemBuilder: (ctx, index) {
        return WishCard(
          height: height,
          width: width,
          index: index,
        );
      },
    );
  }
}
