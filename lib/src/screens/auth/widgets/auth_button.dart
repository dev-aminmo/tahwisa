import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tahwisa/src/style/my_colors.dart';

class AuthButton extends StatefulWidget {
  final String? title;
  final Function? onTap;
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
  _AuthButtonState createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Spacer(
          flex: 1,
        ),
        Expanded(
          flex: 8,
          child: MaterialButton(
            elevation: 4,
            //   minWidth: double.maxFinite,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width * 0.1,
              ),
            ),
            onPressed: widget.onTap as void Function()?,
            child: widget.isGoogle
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 8),
                      SvgPicture.asset("assets/images/google.svg",
                          width: 24, height: 24),
                      const SizedBox(width: 16),
                      Flexible(
                        child: FittedBox(
                          child: Text(
                            widget.title!,
                            maxLines: 1,
                            style: TextStyle(
                                color: (widget.withBackgroundColor)
                                    ? MyColors.white
                                    : MyColors.greenBorder,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                letterSpacing: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  )
                : (!widget.isLoading)
                    ? Text(
                        widget.title!,
                        style: TextStyle(
                            color: (widget.withBackgroundColor)
                                ? MyColors.white
                                : MyColors.greenBorder,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            letterSpacing: 1.5),
                      )
                    : CircularProgressIndicator(),
            color: (widget.withBackgroundColor)
                ? MyColors.greenBorder
                : MyColors.white,
          ),
        ),
        Spacer(
          flex: 1,
        )
      ],
    );
  }
}
