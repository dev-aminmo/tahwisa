import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:tahwisa/style/my_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final bool withBackgroundColor;
  final bool isGoogle;
  final bool isLoading;
  const AuthButton(
      {this.title,
      this.onTap,
      this.withBackgroundColor = false,
      this.isGoogle = false,
      this.isLoading = false});

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
                  Spacer(),
                  SvgPicture.asset("assets/images/google.svg",
                      width: 24, height: 24),
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
                  Spacer(),
                ],
              )
            : (!isLoading)
                ? Text(
                    title,
                    style: TextStyle(
                        color: (withBackgroundColor)
                            ? MyColors.white
                            : MyColors.greenBorder,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 1.5),
                  )
                : CircularProgressIndicator(),
        color: (withBackgroundColor) ? MyColors.greenBorder : MyColors.white,
      ),
    );
  }
}
