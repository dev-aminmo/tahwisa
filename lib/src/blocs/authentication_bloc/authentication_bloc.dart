import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tahwisa/src/repositories/fcm_token_repository.dart';
import 'package:tahwisa/src/repositories/user_repository.dart';

import 'bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;
  final FcmTokenRepository? fcmTokenRepository;

  AuthenticationBloc({
    required this.userRepository,
    required this.fcmTokenRepository,
  }) : super(AuthenticationUninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      final bool hasToken = await userRepository.hasToken();

      if (hasToken) {
        yield AuthenticationAuthenticated();
      } else {
        //yield AuthenticationUninitialized();
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      await userRepository.persistToken(event.token!);
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      try {
        await fcmTokenRepository!.deleteToken();
        var _googleSignIn = GoogleSignIn();
        await _googleSignIn.signOut();
      } catch (e) {
        print(e.toString());
      }
      await userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}
