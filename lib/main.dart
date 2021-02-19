import 'package:flutter/material.dart';
import 'package:tahwisa/screens/auth/login.dart';
import 'package:tahwisa/screens/welcome.dart';
import 'package:tahwisa/style/my_colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahwisa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Lato',
        backgroundColor: MyColors.white,
      ),
      home: LoginScreen(),
    );
  }
}
