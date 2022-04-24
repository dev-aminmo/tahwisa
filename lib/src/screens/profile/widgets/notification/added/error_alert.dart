import 'package:flutter/material.dart';

class ErrorAlert extends StatelessWidget {
  final String message;

  ErrorAlert({this.message = "This post has been handled by another Admin"});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.red,
              size: 72,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                fontSize: 18,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ));
  }
}
