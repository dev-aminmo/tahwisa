import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/app/repositories/models/state.dart';

import 'bloc.dart';

@immutable
abstract class DropDownStateEvent extends Equatable {
  const DropDownStateEvent();
  @override
  List<Object> get props => [];
}

class FetchStates extends DropDownStateEvent {}

class StateChosen extends DropDownStateEvent {
  final MyState? state;
  const StateChosen({
    required this.state,
  });

  @override
  List<Object> get props => [state!];

  @override
  String toString() => 'StateChosen { state: $state }';
}

class ClearState extends DropDownStateEvent {}

class LoadState extends DropDownStateEvent {
  final MyState? selectedState;
  final DropDownsStatesSuccess? dropDownsStatesSuccess;
  const LoadState({
    required this.dropDownsStatesSuccess,
    required this.selectedState,
  });

  @override
  List<Object> get props => [selectedState!, dropDownsStatesSuccess!];

  @override
  String toString() => 'StateLoaded { state: $selectedState }';
}
