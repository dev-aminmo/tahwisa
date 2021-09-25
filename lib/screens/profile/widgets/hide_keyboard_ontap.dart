import 'package:flutter/material.dart';

class HideKeyboardOnTap extends StatelessWidget {
  const HideKeyboardOnTap({this.child});
  final child;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          print("taped");
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: child);
  }
}
