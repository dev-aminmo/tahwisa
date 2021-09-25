import 'package:flutter/material.dart';
import 'package:tahwisa/style/my_colors.dart';

class AuthInput extends StatelessWidget {
  final hint;
  final suffix;
  final bool obscured;
  final controller;
  final validator;

  AuthInput(
      {@required this.hint,
      this.suffix,
      this.obscured = false,
      this.controller,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          validator: validator,
          controller: controller,
          keyboardType: (hint == "email") ? TextInputType.emailAddress : null,
          obscureText: obscured,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                left: 16,
                top: 22,
                bottom: 22,
              ),
              hintText: hint,
              suffixIcon: suffix,
              counterText: "",
              errorStyle: TextStyle(fontSize: 16),
              hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color(0xff8FA0B3),
                  fontSize: 18),
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
