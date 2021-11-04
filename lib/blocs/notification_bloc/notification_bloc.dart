import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/repositories/models/notification.dart';
import 'package:tahwisa/repositories/notification_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationRepository notificationRepository;
  NotificationBloc({
    @required this.notificationRepository,
  }) : super(NotificationInitial()) {
    add(FetchNotifications());
  }

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is FetchNotifications) {
      yield NotificationLoading();
      try {
        final notifications = await notificationRepository.fetchNotifications();
        yield NotificationSuccess(notifications: notifications);
      } catch (error) {
        yield NotificationFailure(error: error.toString());
      }
    }
  }
}
