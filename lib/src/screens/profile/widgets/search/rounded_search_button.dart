import 'package:flutter/material.dart';
import 'package:tahwisa/src/style/my_colors.dart';

class RoundedSearchButton extends StatelessWidget {
  const RoundedSearchButton({
    this.searchIconClicked,
  });
  final searchIconClicked;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: searchIconClicked,
      padding: EdgeInsets.all(12),
      fillColor: MyColors.lightGreen,
      child: Icon(Icons.search, color: Colors.white),
      shape: CircleBorder(),
    );
  }
}
