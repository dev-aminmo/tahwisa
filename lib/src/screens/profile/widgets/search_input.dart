import 'package:flutter/material.dart';
import 'package:tahwisa/src/style/my_colors.dart';

class SearchInput extends StatelessWidget {
  final hint = "search for a place";
  final height;
  final width;
  SearchInput(this.height, this.width);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            left: width * 0.07,
            top: height * 0.025,
            bottom: height * 0.025,
          ),
          hintText: hint,
          counterText: "",
          errorStyle: TextStyle(fontSize: 16),
          hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              color: Color(0xff8FA0B3),
              fontSize: 20),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(width * 0.1),
              borderSide: BorderSide(color: MyColors.lightGreen, width: 1.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(width * 0.03),
              borderSide: BorderSide(color: MyColors.lightGreen, width: 2.5))),
      cursorColor: MyColors.lightGreen,
      style: TextStyle(
          fontWeight: FontWeight.w400, color: MyColors.darkBlue, fontSize: 20),
    );
  }
}
