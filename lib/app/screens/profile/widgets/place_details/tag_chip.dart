import 'package:flutter/material.dart';
import 'package:tahwisa/app/style/my_colors.dart';

class TagChip extends StatelessWidget {
  const TagChip(
    this.label,
  );
  final label;
  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: EdgeInsets.all(2.0),
      label: Text(
        "#" + label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: MyColors.greenBorder,
      elevation: 3.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    );
  }
}
