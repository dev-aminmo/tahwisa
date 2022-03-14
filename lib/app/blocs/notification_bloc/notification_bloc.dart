import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:tahwisa/app/repositories/models/notification.dart';
import 'package:tahwisa/app/repositories/notification_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  List<Notification>? _notifications;
  final _notifications$ = BehaviorSubject<List<Notification>?>();
  Stream<List<Notification>?> get notifications => _notifications$;
  final _unreadNotifications$ = BehaviorSubject<int>();
  Stream<int> get unreadNotifications => _unreadNotifications$;
  NotificationRepository notificationRepository;
  var test = "hello";
  NotificationBloc({
    required this.notificationRepository,
  }) : super(NotificationInitial()) {
    add(FetchNotifications());
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("************************************");
      print('Got a message whilst in the foreground!');
      if (message.notification != null) {
        print('Message also contained a data: ${message.data}');
        add(PushNotification(
            notification: Notification(
          id: message.data['id'],
          title: message.notification?.title,
          body: message.notification?.body,
          description: message.data['description'],
          placeId: message.data['place_id'],
          type: message.data['type'],
        )));
      }
    });
    _notifications$.listen((notificationsList) {
      var count = 0;
      for (var notification in notificationsList!) {
        if (!notification.read!) count++;
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
        _notifications!.insert(0, event.notification);
        _notifications$.add(_notifications);
      } catch (error) {
        yield NotificationFailure(error: error.toString());
      }
    }
    if (event is ReadNotification) {
      try {
        int index = this._notifications!.indexWhere(
            (notification) => (notification.id == event.id) ? true : false);
        if (index != -1) {
          _notifications!.elementAt(index).read = true;
          _notifications$.add(_notifications);
        }
        notificationRepository.readNotification(id: event.id);
      } catch (e) {}
    }
  }

  @override
  Future<void> close() {
    _notifications$.close();
    _unreadNotifications$.close();
    return super.close();
  }
}
