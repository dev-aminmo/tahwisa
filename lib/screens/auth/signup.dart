import 'package:flutter/material.dart';
import 'package:tahwisa/style/my_colors.dart';
import './widgets/auth_button.dart';
import './widgets/auth_input.dart';

class SignUPScreen extends StatefulWidget {
  @override
  _SignUPScreenState createState() => _SignUPScreenState();
}

class _SignUPScreenState extends State<SignUPScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(height: 100),
          AuthInput(
              hint: "username",
              suffix: Icon(Icons.person_outline, color: MyColors.lightGreen)),
          AuthInput(
              hint: "email",
              suffix: Icon(Icons.mail_outlined, color: MyColors.lightGreen)),
          AuthInput(
            hint: "password",
            suffix:
                Icon(Icons.remove_red_eye_outlined, color: MyColors.lightGreen),
            obscured: true,
          ),
          AuthButton(
            title: "Sign up",
            onTap: () {},
          ),
          Text("-or-",
              style: TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
          AuthButton(title: "Sign up with Google", onTap: () {}),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
