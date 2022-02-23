import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tahwisa/repositories/fcm_token_repository.dart';

part 'fcm_token_state.dart';

class FcmCubit extends Cubit<FcmTokenState> {
  final FcmTokenRepository repository;

  FcmCubit({required this.repository}) : super(FcmTokenInitial()) {
    _updateFcmToken();
  }

  void add({required String token}) async {
    emit(FcmTokenLoading());
    try {
      var response = await repository.add(fcmToken: token);
      if (response) {
        emit(FcmTokenSuccess());
      }
    } catch (e) {
      emit(FcmTokenError());
    }
  }

  void _updateFcmToken() async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? fcmToken = pref.getString("fcm_token");
      if (fcmToken == null) {
        FirebaseMessaging messaging = FirebaseMessaging.instance;
        fcmToken = await messaging.getToken();
        await pref.setString("fcm_token", fcmToken!);
      }
      String? apiFcmToken = pref.getString("api_fcm_token");
      if (fcmToken != apiFcmToken) {
        add(token: fcmToken);
      }
    } catch (e) {
      print(e);
    }
  }
}
