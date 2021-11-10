part of 'refuse_place_messages_cubit.dart';

@immutable
abstract class RefusePlaceMessagesState {}

class RefusePlaceMessagesInitial extends RefusePlaceMessagesState {}

class RefusePlaceMessagesLoading extends RefusePlaceMessagesState {}

class RefusePlaceMessagesSuccess extends RefusePlaceMessagesState {
  final List<RefusePlaceMessage> refusePlaceMessages;

  RefusePlaceMessagesSuccess({@required this.refusePlaceMessages});
}

class RefusePlaceMessagesError extends RefusePlaceMessagesState {}
