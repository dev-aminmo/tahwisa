import 'package:flutter/material.dart';
import 'package:tahwisa/src/cubits/wish_place_cubit/wish_place_cubit.dart';
import 'package:tahwisa/src/style/my_colors.dart';

class TitleAndWishRow extends StatefulWidget {
  const TitleAndWishRow({
    Key? key,
    required this.title,
    required this.placeId,
    required this.wished,
    required this.wishPlaceCubit,
  }) : super(key: key);

  final String? title;
  final bool? wished;
  final WishPlaceCubit wishPlaceCubit;
  final placeId;

  @override
  _TitleAndWishRowState createState() => _TitleAndWishRowState();
}

class _TitleAndWishRowState extends State<TitleAndWishRow> {
  bool? wished;

  @override
  void initState() {
    super.initState();
    wished = widget.wished;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            widget.title!,
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
            onTap: () {
              if (!wished!) {
                setState(() {
                  wished = true;
                });
                widget.wishPlaceCubit.addToWishList(widget.placeId);
              } else {
                setState(() {
                  wished = false;
                });
                widget.wishPlaceCubit.removeFromWishList(widget.placeId);
              }
            },
            child: Icon(
              //Icons.favorite_outlined,
              wished! ? Icons.favorite_outlined : Icons.favorite_border,
              color: MyColors.lightGreen,
              size: 32,
            ),
          ),
        ),
      ],
    );
  }
}
