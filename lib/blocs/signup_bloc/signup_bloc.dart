import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import '../authentication_bloc/bloc.dart';
import 'bloc.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final userRepository;
  final authenticationBloc;

  SignupBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null),
        super(SignupInitial());

  @override
  SignupState get initialState => SignupInitial();

  @override
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    if (event is SignupButtonPressed) {
      yield SignupLoading();
      try {
        final token = await userRepository.register(
          username: event.username,
          email: event.email,
          password: event.password,
        );

        authenticationBloc.add(LoggedIn(token: token));
      } catch (error) {
        yield SignupFailure(error: error.toString());
      }
    }
    if (event is GoogleButtonPressed) {
      yield SignupLoading();
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
        yield SignupFailure(error: error.toString());
      }
    }
  }
}
