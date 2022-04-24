part of 'user_cubit.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserSuccess extends UserState {
  final User user;
  UserSuccess(this.user);
}

class UserFailure extends UserState {}
