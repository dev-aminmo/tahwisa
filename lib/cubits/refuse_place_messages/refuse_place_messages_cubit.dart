import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/repositories/models/refuse_place_message.dart';
import 'package:tahwisa/repositories/refuse_place_message_repository.dart';

part 'refuse_place_messages_state.dart';

class RefusePlaceMessagesCubit extends Cubit<RefusePlaceMessagesState> {
  RefusePlaceMessageRepository refusePlaceMessageRepository;

  RefusePlaceMessagesCubit(this.refusePlaceMessageRepository)
      : super(RefusePlaceMessagesInitial());
  getRefusePlaceMessages(var placeId) async {
    try {
      emit(RefusePlaceMessagesLoading());
      var messages = await refusePlaceMessageRepository.getRefusePlaceMessages(
          placeId: placeId);
      (messages)
          ? emit(RefusePlaceMessagesSuccess(refusePlaceMessages: messages))
          : emit(RefusePlaceMessagesError());
    } catch (e) {
      emit(RefusePlaceMessagesError());
    }
  }

  getAdminRefusePlaceMessages() async {
    try {
      emit(RefusePlaceMessagesLoading());
      var messages =
          await refusePlaceMessageRepository.getAdminRefusePlaceMessages();
      (messages)
          ? emit(RefusePlaceMessagesSuccess(refusePlaceMessages: messages))
          : emit(RefusePlaceMessagesError());
    } catch (e) {
      emit(RefusePlaceMessagesError());
    }
  }
}
