import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();
  @override
  List<Object> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {}

class ResetPasswordFailure extends ResetPasswordState {
  final String error;

  const ResetPasswordFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ResetPasswordFailure { error: $error }';
}
