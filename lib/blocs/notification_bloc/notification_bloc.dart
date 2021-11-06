import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:tahwisa/repositories/models/notification.dart';
import 'package:tahwisa/repositories/notification_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  List<Notification> _notifications;
  final _notifications$ = BehaviorSubject<List<Notification>>();
  Stream<List<Notification>> get notifications => _notifications$;
  final _unreadNotifications$ = BehaviorSubject<int>();
  Stream<int> get unreadNotifications => _unreadNotifications$;
  NotificationRepository notificationRepository;
  NotificationBloc({
    @required this.notificationRepository,
  }) : super(NotificationInitial()) {
    add(FetchNotifications());
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("************************************");

      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        add(PushNotification(
            notification: Notification(
                title: message.notification?.title, body: "ha tabradi hah")));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked! yaWz ********************************');
    });
    _notifications$.listen((notificationsList) {
      var count = 0;
      for (var notification in notificationsList) {
        if (!notification.read) count++;
      }
      _unreadNotifications$.add(count);
    });
  }

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is FetchNotifications) {
      if (event.loading) yield NotificationLoading();
      try {
        _notifications = [];
        _notifications = await notificationRepository.fetchNotifications();
        _notifications$.add(_notifications);
        yield NotificationSuccess(notifications: _notifications);
      } catch (error) {
        yield NotificationFailure(error: error.toString());
      }
    }
    if (event is PushNotification) {
      try {
        _notifications.insert(0, event.notification);
        _notifications$.add(_notifications);
      } catch (error) {
        yield NotificationFailure(error: error.toString());
      }
    }
  }

  @override
  Future<Function> close() {
    _notifications$.close();
    _unreadNotifications$.close();
    super.close();
  }
}

/*
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("************************************");
  print("Handling a background message: ${message.messageId}");
  print("Handling a background data: ${message.data}");
}
*/
