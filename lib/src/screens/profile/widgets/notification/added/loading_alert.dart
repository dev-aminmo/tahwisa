import 'package:flutter/material.dart';

class LoadingAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
            backgroundColor: Colors.white,
            content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [CircularProgressIndicator()])));
  }
}
