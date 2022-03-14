import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Page404 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SvgPicture.asset(
        "assets/images/404page.svg",
      ),
    );
  }
}
