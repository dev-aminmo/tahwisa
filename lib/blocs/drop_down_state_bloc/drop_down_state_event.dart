import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/repositories/models/state.dart';

@immutable
abstract class DropDownStateEvent extends Equatable {
  const DropDownStateEvent();
}

class FetchStates extends DropDownStateEvent {
  @override
  List<Object> get props => [];
}

class StateChosen extends DropDownStateEvent {
  final MyState state;
  const StateChosen({
    @required this.state,
  });

  @override
  List<Object> get props => [state];

  @override
  String toString() => 'StateChosen { state: $state }';
}