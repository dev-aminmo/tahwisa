import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/repositories/fcm_token_repository.dart';

part 'fcm_token_state.dart';

class FcmCubit extends Cubit<FcmTokenState> {
  final FcmTokenRepository repository;
  FcmCubit({@required this.repository}) : super(FcmTokenInitial());

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
}
