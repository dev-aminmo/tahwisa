part of 'notification_bloc.dart';

@immutable
abstract class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final List<Notification> notifications;
  NotificationSuccess({this.notifications});

  @override
  List<Object> get props => [notifications];
}

class NotificationFailure extends NotificationState {
  final String error;

  const NotificationFailure({
    @required this.error,
  });

  @override
  List<Object> get props => [error];

  @override
  String toString() => ' { NotificationFailure error: $error }';
}
