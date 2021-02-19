import 'package:flutter/material.dart';
import 'package:tahwisa/style/my_colors.dart';

class AuthButton extends StatelessWidget {
  final String title;
  final Function onTap;
  const AuthButton({this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.08,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width * 0.1,
            ),
            side: BorderSide(color: MyColors.greenBorder, width: 2)),
        onPressed: onTap,
        child: Text(
          title,
          style: TextStyle(color: MyColors.greenBorder),
        ),
        color: MyColors.white,
      ),
    );
  }
}
