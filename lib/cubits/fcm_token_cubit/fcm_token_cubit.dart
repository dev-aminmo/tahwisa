import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tahwisa/repositories/fcm_token_repository.dart';

part 'fcm_token_state.dart';

class FcmCubit extends Cubit<FcmTokenState> {
  final FcmTokenRepository repository;
  FcmCubit({@required this.repository}) : super(FcmTokenInitial()) {
    _updateFcmToken();
  }

  void add({@required String token}) async {
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

  void _updateFcmToken() {
    SharedPreferences.getInstance().then((pref) {
      String fcmToken = pref.getString("fcm_token");
      String apiFcmToken = pref.getString("api_fcm_token");
      print(fcmToken != apiFcmToken);
      if (fcmToken != apiFcmToken) add(token: fcmToken);
    });
  }
}
