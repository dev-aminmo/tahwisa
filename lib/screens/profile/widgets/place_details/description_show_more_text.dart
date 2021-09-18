import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:tahwisa/style/my_colors.dart';

class DescriptionShowMoreText extends StatefulWidget {
  const DescriptionShowMoreText({
    Key key,
    @required this.text,
  }) : super(key: key);

  final text;

  @override
  _DescriptionShowMoreTextState createState() =>
      _DescriptionShowMoreTextState();
}

class _DescriptionShowMoreTextState extends State<DescriptionShowMoreText> {
  bool _readMore = true;
  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      widget.text,
      callback: (bool) {
        print(bool);
        setState(() {
          _readMore = bool;
        });
      },
      delimiter: _readMore ? '...' : '',
      trimLines: 2,
      colorClickableText: MyColors.lightGreen,
      trimMode: TrimMode.Line,
      style: TextStyle(color: MyColors.gray),
      trimCollapsedText: ' Show more',
      trimExpandedText: ' Show less',
      lessStyle: TextStyle(
          fontSize: 16,
          color: MyColors.lightGreen,
          fontWeight: FontWeight.bold),
      moreStyle: TextStyle(
          fontSize: 16,
          color: MyColors.lightGreen,
          fontWeight: FontWeight.bold),
    );
  }
}
