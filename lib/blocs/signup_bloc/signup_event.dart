import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SignupEvent extends Equatable {
  const SignupEvent();
  @override
  List<Object> get props => [];
}

class SignupButtonPressed extends SignupEvent {
  final String username;
  final String email;
  final String password;

  const SignupButtonPressed({
    @required this.username,
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [username, email, password];

  @override
  String toString() =>
      'LoginButtonPressed { username: $email, password: $password }';
}

class GoogleButtonPressed extends SignupEvent {
  @override
  String toString() => 'GoogleButtonPressed';
}
