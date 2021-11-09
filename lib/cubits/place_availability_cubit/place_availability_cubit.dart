import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/repositories/admin_repository.dart';

part 'place_availability_state.dart';

class PlaceAvailabilityCubit extends Cubit<PlaceAvailabilityState> {
  final AdminRepository adminRepository;

  PlaceAvailabilityCubit(this.adminRepository)
      : super(PlaceAvailabilityInitial());
  checkIfPlaceIsAvailable(placeId) async {
    try {
      var response =
          await adminRepository.checkIfPlaceIsAvailable(placeId: placeId);
      (response) ? emit(PlaceAvailable()) : emit(PlaceUnAvailable());
    } catch (e) {
      emit(PlaceUnAvailable());
    }
  }
}
