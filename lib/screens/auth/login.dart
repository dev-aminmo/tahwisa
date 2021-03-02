import 'package:flutter/material.dart';
import 'package:tahwisa/style/my_colors.dart';
import './widgets/auth_button.dart';
import './widgets/auth_input.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Spacer(
            flex: 5,
          ),
          AuthInput(
              hint: "email",
              suffix: Icon(Icons.person_outline, color: MyColors.lightGreen)),
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
            title: "Login",
            onTap: () {},
            withBackgroundColor: true,
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
            title: "Login with Google",
            onTap: () {},
            isGoogle: true,
          ),
          Spacer(
            flex: 5,
          ),
        ],
      ),
    );
  }
}
