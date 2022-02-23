import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/repositories/models/user.dart';
import 'package:tahwisa/repositories/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository? userRepository;

  UserCubit({required this.userRepository}) : super(UserInitial()) {
    fetchUser();
  }
//UserCubit() : super(UserInitial());

  void fetchUser() async {
    try {
      var user = await userRepository!.user();
      emit(UserSuccess(user));
    } catch (e) {
      print(e);
      emit(UserFailure());
    }
  }
}
