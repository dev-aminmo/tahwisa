import 'package:flutter/material.dart';
import 'package:tahwisa/style/my_colors.dart';

class AuthButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final bool withBackgroundColor;
  const AuthButton({this.title, this.onTap, this.withBackgroundColor = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.08,
      child: RaisedButton(
        elevation: 7,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width * 0.1,
            ),
            side: BorderSide(
                color: (withBackgroundColor)
                    ? Colors.transparent
                    : MyColors.greenBorder,
                width: 2)),
        onPressed: onTap,
        child: Text(
          title,
          style: TextStyle(
              color:
                  (withBackgroundColor) ? MyColors.white : MyColors.greenBorder,
              fontSize: 22,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.5),
        ),
        color: (withBackgroundColor) ? MyColors.greenBorder : MyColors.white,
      ),
    );
  }
}
