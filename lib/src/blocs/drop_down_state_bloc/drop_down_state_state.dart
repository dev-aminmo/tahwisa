import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/src/repositories/models/state.dart';

@immutable
abstract class DropDownState extends Equatable {
  const DropDownState();
  @override
  List<Object> get props => [];
}

class DropDownStateInitial extends DropDownState {}

class DropDownsStateLoading extends DropDownState {}

class DropDownsStatesSuccess extends DropDownState {
  final List<MyState>? states;
  DropDownsStatesSuccess({this.states});
  @override
  List<Object> get props => [states!];
}

class DropDownStateFailure extends DropDownState {
  final String error;

  const DropDownStateFailure({
    required this.error,
  });

  @override
  List<Object> get props => [error];

  @override
  String toString() => ' { error: $error }';
}
