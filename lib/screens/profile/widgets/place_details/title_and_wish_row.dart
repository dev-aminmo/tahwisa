import 'package:flutter/material.dart';
import 'package:tahwisa/style/my_colors.dart';

class TitleAndWishRow extends StatelessWidget {
  const TitleAndWishRow({
    Key key,
    @required this.title,
    @required this.wished,
  }) : super(key: key);

  final String title;
  final bool wished;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            title,
            textAlign: TextAlign.left,
            softWrap: true,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
                color: MyColors.darkBlue),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(
              Radius.circular(32.0),
            ),
            onTap: () {},
            child: Icon(
              //Icons.favorite_outlined,
              (wished) ? Icons.favorite_outlined : Icons.favorite_border,
              color: MyColors.lightGreen,
              size: 32,
            ),
          ),
        ),
      ],
    );
  }
}
