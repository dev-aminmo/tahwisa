import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/blocs/notification_bloc/notification_bloc.dart';
import 'package:tahwisa/style/my_colors.dart';

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
      if (state is NotificationLoading) {}
      if (state is NotificationSuccess) {
        var notifications = state.notifications;
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: notifications.length,
          itemBuilder: (ctx, index) {
            return ListTile(
              title: Text(notifications[index].title),
              subtitle: Text(notifications[index].body),
            );
          },
        );
      }
      return Center(
          child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.all(width * 0.07),
                child: Image.asset(
                  'assets/images/flame-no-messages.png',
                )),
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
                    style:
                        TextStyle(color: MyColors.greenBorder, fontSize: 22)),
              ),
            )
          ],
        ),
      ));
    });
  }
}
