import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

//part of 'signup_bloc.dart';

@immutable
abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupFailure extends SignupState {
  final String error;

  const SignupFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'SignupFailure { error: $error }';
}
