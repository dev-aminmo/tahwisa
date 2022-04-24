import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();
}

class ResetPasswordButtonPressed extends ResetPasswordEvent {
  final String email;

  ResetPasswordButtonPressed({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'ResetPasswordButtonPressed { $email }';
}
