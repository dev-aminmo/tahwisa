import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'bloc.dart';
import '../authentication_bloc/bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final userRepository;
  final authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null),
        super(LoginInitial());

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {
        final token = await userRepository.authenticate(
          username: event.username,
          password: event.password,
        );

        authenticationBloc.add(LoggedIn(token: token));

        yield LoginInitial();
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
