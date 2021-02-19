import 'package:flutter/material.dart';
import 'package:tahwisa/style/my_colors.dart';
import './widgets/auth_button.dart';
import './widgets/auth_input.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(height: 100),
          AuthInput(
              hint: "email",
              suffix: Icon(Icons.person_outline, color: MyColors.lightGreen)),
          AuthInput(
            hint: "password",
            suffix:
                Icon(Icons.remove_red_eye_outlined, color: MyColors.lightGreen),
            obscured: true,
          ),
          AuthButton(
            title: "Login",
            onTap: () {},
          ),
          Text("-or-",
              style: TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
          AuthButton(title: "Login with Google", onTap: () {}),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
