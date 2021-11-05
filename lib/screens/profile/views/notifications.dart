import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/blocs/notification_bloc/notification_bloc.dart';
import 'package:tahwisa/repositories/models/notification.dart' as my;
import 'package:tahwisa/style/my_colors.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  NotificationBloc _notificationBloc;
  @override
  void initState() {
    super.initState();
    _notificationBloc = context.read<NotificationBloc>();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
      if (state is NotificationLoading) {
        return Center(child: CircularProgressIndicator());
      }
      if (state is NotificationSuccess) {
        return StreamBuilder<List<my.Notification>>(
            stream: _notificationBloc.notifications,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length == 0) {
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
                                    style: TextStyle(
                                        color: MyColors.greenBorder,
                                        fontSize: 22)))),
                      ])));
                }
                return ListView.separated(
                  separatorBuilder: (ctx, index) {
                    return Divider(
                      endIndent: 16,
                      indent: 16,
                    );
                  },
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (ctx, index) {
                    return ListTile(
                      title: Text(
                        snapshot.data[index].title,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(snapshot.data[index].body),
                    );
                  },
                );
              }
              return SizedBox();
            });
      }
      return SizedBox();
    });
  }
}
