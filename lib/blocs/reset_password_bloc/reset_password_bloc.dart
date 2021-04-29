import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'bloc.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final userRepository;

  ResetPasswordBloc({
    @required this.userRepository,
  })  : assert(userRepository != null),
        super(ResetPasswordInitial());

  @override
  Stream<ResetPasswordState> mapEventToState(
    ResetPasswordEvent event,
  ) async* {
    if (event is ResetPasswordButtonPressed) {
      yield ResetPasswordLoading();
      try {
        var response = await userRepository.resetPassword(email: event.email);
        if (response) {
          yield (ResetPasswordSuccess());
        } else {
          yield ResetPasswordFailure(
              error: "Could not found an account with that email address");
        }
      } catch (error) {
        yield ResetPasswordFailure(error: error.toString());
      }
    }
  }
}
