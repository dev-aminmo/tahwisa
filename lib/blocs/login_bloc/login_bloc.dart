import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import '../authentication_bloc/bloc.dart';
import 'bloc.dart';

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
          email: event.email,
          password: event.password,
        );

        authenticationBloc.add(LoggedIn(token: token));

        // yield LoginInitial();
      } catch (error) {
        yield LoginInitial();
        yield LoginFailure(error: error.toString());
      }
    }
    if (event is GoogleButtonPressed) {
      yield LoginLoading();
      try {
        var _googleSignIn = GoogleSignIn();
        var user = await _googleSignIn.signIn();
        var authenticated_user = await user.authentication;
        if (authenticated_user == null) {
          throw ("cannot log in with this account");
        }
        final token = await userRepository.social(
          accessToken: authenticated_user.accessToken,
        );

        authenticationBloc.add(LoggedIn(token: token));
      } catch (error) {
        yield LoginInitial();

        yield LoginFailure(error: error.toString());
      }
    }
  }
}
