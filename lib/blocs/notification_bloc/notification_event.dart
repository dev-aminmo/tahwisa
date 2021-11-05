part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object> get props => [];
}

class FetchNotifications extends NotificationEvent {
  final bool loading;

  FetchNotifications({this.loading = true});
}

class PushNotification extends NotificationEvent {
  final Notification notification;

  PushNotification({@required this.notification});
  @override
  List<Object> get props => [notification];
}
