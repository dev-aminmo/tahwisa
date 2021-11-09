import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/repositories/admin_repository.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final AdminRepository adminRepository;

  AdminCubit(this.adminRepository) : super(AdminInitial());
  approvePlace(var placeId) async {
    try {
      emit(AdminLoading());
      var response = await adminRepository.approvePlace(placeId: placeId);
      (response) ? emit(AdminSuccess()) : emit(AdminError());
    } catch (e) {
      emit(AdminError());
    }
  }
}
