import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/app/repositories/admin_repository.dart';
import 'package:tahwisa/app/repositories/models/refuse_place_message.dart';

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

  refusePlace(
      {required var placeId,
      required List<RefusePlaceMessage> messages,
      required var description}) async {
    // try {
    emit(AdminLoading());
    var ids = [];
    for (var message in messages) {
      ids.add(message.id);
    }
    print(ids);
    var response = await adminRepository.refusePlace(
        placeId: placeId, messages: ids, description: description);
    (response) ? emit(AdminSuccess()) : emit(AdminError());
    //  } catch (e) {
    // emit(AdminError());
    //   }
  }
}
