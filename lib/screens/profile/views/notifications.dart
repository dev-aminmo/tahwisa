import 'package:flutter/material.dart';
import 'package:tahwisa/style/my_colors.dart';

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Center(
        child: SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(width * 0.07),
            child: Image.asset(
              'assets/images/flame-no-messages.png',
            ),
          ),
          SizedBox(
            height: height * 0.05,
            width: width,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.03,
            ),
            child: FittedBox(
              alignment: Alignment.center,
              child: Text("You don't have any notifications",
                  style: TextStyle(color: MyColors.greenBorder, fontSize: 22)),
            ),
          )
        ],
      ),
    ));
  }
}
