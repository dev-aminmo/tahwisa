part of 'drop_down_state_cubit.dart';

@immutable
abstract class DropDownStateState extends Equatable {
  const DropDownStateState();
  @override
  List<Object> get props => [];
}

class DropDownStateInitial extends DropDownStateState {}

class DropDownStateLoadingState extends DropDownStateState {}

class DropDownStateLoadedState extends DropDownStateState {
  DropDownStateLoadedState(this.states);
  final List<MyState> states;

  @override
  List<Object> get props => [states];
}

class ErrorState extends DropDownStateState {}
