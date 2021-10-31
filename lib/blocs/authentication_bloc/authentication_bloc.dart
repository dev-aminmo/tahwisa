import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/repositories/fcm_token_repository.dart';
import 'package:tahwisa/repositories/user_repository.dart';

import 'bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;
  final FcmTokenRepository fcmTokenRepository;

  AuthenticationBloc({
    @required this.userRepository,
    @required this.fcmTokenRepository,
  })  : assert(userRepository != null),
        super(AuthenticationUninitialized());

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
      await userRepository.persistToken(event.token);
      //await userRepository.user();

      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      //TODO delete fcm token in back
      await userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}
