import 'package:flutter/material.dart';
import 'package:tahwisa/blocs/notification_bloc/notification_bloc.dart';

class NotificationDetails extends StatefulWidget {
  static const String routeName = '/notification_details';

  static Route route({@required NotificationBloc notificationBloc}) {
    return MaterialPageRoute(
      builder: (_) => NotificationDetails(
        notificationBloc: notificationBloc,
      ),
      settings: RouteSettings(name: routeName),
    );
  }

  final NotificationBloc notificationBloc;

  const NotificationDetails({this.notificationBloc});
  @override
  _NotificationDetailsState createState() => _NotificationDetailsState();
}

class _NotificationDetailsState extends State<NotificationDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
            "Notification NotificationDetails${widget.notificationBloc.test}"),
      ),
    );
  }
}
