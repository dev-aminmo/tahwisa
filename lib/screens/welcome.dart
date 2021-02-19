import "package:flutter/material.dart";
import 'package:tahwisa/style/my_colors.dart';
import 'package:tahwisa/widgets/auth_button.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex: 3, child: SizedBox()),
          AuthButton(
            title: "Sign in",
            onTap: () {},
          ),
          SizedBox(height: height * 0.1),
          AuthButton(
            title: "Sign up",
            onTap: () {},
          ),
          Expanded(flex: 1, child: SizedBox()),
        ],
      ),
    ));
  }
}
