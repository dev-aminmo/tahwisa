import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../authentication_bloc/bloc.dart';
import 'bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final userRepository;
  final authenticationBloc;

  LoginBloc({
    required this.userRepository,
    required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null),
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {
        print(".***************************** login button after pressed .");
        final token = await userRepository.authenticate(
          email: event.email,
          password: event.password,
        );
        print("************************* token has been getted");

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
        GoogleSignInAccount? user = await _googleSignIn.signIn();
        var authenticatedUser = await user?.authentication;
        if (authenticatedUser == null) {
          throw ("cannot log in with this account");
        }
        final token = await userRepository.social(
          accessToken: authenticatedUser.accessToken,
        );

        authenticationBloc.add(LoggedIn(token: token));
      } catch (error) {
        yield LoginInitial();

        yield LoginFailure(error: error.toString());
      }
    }
  }
}
