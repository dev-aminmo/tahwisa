import 'package:flutter/material.dart';
import 'package:tahwisa/blocs/wishlist_bloc/bloc.dart';
import 'package:tahwisa/style/my_colors.dart';

class TitleAndWishRow extends StatefulWidget {
  const TitleAndWishRow({
    Key key,
    @required this.title,
    @required this.placeId,
    @required this.wished,
    @required this.wishListBloc,
  }) : super(key: key);

  final String title;
  final bool wished;
  final WishListBloc wishListBloc;
  final placeId;

  @override
  _TitleAndWishRowState createState() => _TitleAndWishRowState();
}

class _TitleAndWishRowState extends State<TitleAndWishRow> {
  bool wished;

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
            widget.title,
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
              if (!wished) {
                setState(() {
                  wished = true;
                });
                widget.wishListBloc.add(AddToWishList(placeId: widget.placeId));
              } else {
                setState(() {
                  wished = false;
                });
                widget.wishListBloc
                    .add(RemoveFromWishList(placeId: widget.placeId));
              }
            },
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
