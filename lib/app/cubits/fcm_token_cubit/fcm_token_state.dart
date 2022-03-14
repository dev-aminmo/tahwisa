part of 'fcm_token_cubit.dart';

@immutable
abstract class FcmTokenState {}

class FcmTokenInitial extends FcmTokenState {}

class FcmTokenLoading extends FcmTokenState {}

class FcmTokenSuccess extends FcmTokenState {}

class FcmTokenError extends FcmTokenState {}
