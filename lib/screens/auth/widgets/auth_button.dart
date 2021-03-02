import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:tahwisa/style/my_colors.dart';

class AuthButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final bool withBackgroundColor;
  final bool isGoogle;
  const AuthButton(
      {this.title,
      this.onTap,
      this.withBackgroundColor = false,
      this.isGoogle = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.08,
      child: RaisedButton(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width * 0.1,
          ),
          /*side: BorderSide(
                color: (withBackgroundColor)
                    ? Colors.transparent
                    : MyColors.greenBorder,
                width: 2)*/
        ),
        onPressed: onTap,
        child: isGoogle
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                      height: 24,
                      width: 24,
                      image: Svg("assets/images/google.svg")),
                  Spacer(),
                  FittedBox(
                    child: Text(
                      title,
                      style: TextStyle(
                          color: (withBackgroundColor)
                              ? MyColors.white
                              : MyColors.greenBorder,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 1.5),
                    ),
                  ),
                ],
              )
            : Text(
                title,
                style: TextStyle(
                    color: (withBackgroundColor)
                        ? MyColors.white
                        : MyColors.greenBorder,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1.5),
              ),
        color: (withBackgroundColor) ? MyColors.greenBorder : MyColors.white,
      ),
    );
  }
}
