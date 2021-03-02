import 'package:flutter/material.dart';
import 'package:tahwisa/style/my_colors.dart';
import './widgets/auth_button.dart';
import './widgets/auth_input.dart';

class SignUPScreen extends StatefulWidget {
  @override
  _SignUPScreenState createState() => _SignUPScreenState();
}

class _SignUPScreenState extends State<SignUPScreen> {
  bool obscured = true;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MyColors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(height: height * 0.1),
          AuthInput(
              hint: "username",
              suffix: Icon(Icons.person_outline, color: MyColors.lightGreen)),
          AuthInput(
              hint: "email",
              suffix: Icon(Icons.mail_outlined, color: MyColors.lightGreen)),
          AuthInput(
            hint: "password",
            suffix: GestureDetector(
                onTap: () {
                  setState(() {
                    obscured = !obscured;
                  });
                },
                child: obscured
                    ? Icon(Icons.remove_red_eye_outlined,
                        color: MyColors.lightGreen)
                    : Icon(Icons.visibility_off_outlined,
                        color: MyColors.lightGreen)),
            obscured: obscured,
          ),
          Spacer(
            flex: 5,
          ),
          AuthButton(
            title: "Sign up",
            withBackgroundColor: true,
            onTap: () {},
          ),
          Spacer(),
          Text("-or-",
              style: TextStyle(
                  fontSize: 22,
                  color: MyColors.darkBlue,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold)),
          Spacer(),
          AuthButton(
            title: "Sign up with Google",
            onTap: () {},
            isGoogle: true,
          ),
          Spacer(
            flex: 5,
          )
        ],
      ),
    );
  }
}
