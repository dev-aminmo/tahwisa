import 'package:flutter/material.dart';
import 'package:tahwisa/style/my_colors.dart';

class AuthInput extends StatelessWidget {
  final hint;
  final suffix;
  bool obscured;

  AuthInput({@required this.hint, this.suffix, this.obscured = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(15),
        child: TextFormField(
          obscureText: obscured,
          decoration: InputDecoration(
              hintText: hint,
              suffixIcon: suffix,
              counterText: "",
              errorStyle: TextStyle(fontSize: 16),
              hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color(0xff8FA0B3),
                  fontSize: 20),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      BorderSide(color: MyColors.lightGreen, width: 1.5)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      BorderSide(color: MyColors.lightGreen, width: 2.5))),
          cursorColor: MyColors.lightGreen,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              color: MyColors.darkBlue,
              fontSize: 20),
        ));
  }
}
