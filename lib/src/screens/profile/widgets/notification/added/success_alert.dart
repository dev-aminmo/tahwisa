import 'package:flutter/material.dart';
import 'package:tahwisa/src/style/my_colors.dart';

class SuccessAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outlined,
              color: Colors.green,
              size: 72,
            ),
            const SizedBox(height: 16),
            const Text(
              "Your request has been successfully submitted",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  color: MyColors.darkBlue),
            ),
            const SizedBox(height: 16),
          ],
        ));
  }
}
