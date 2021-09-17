import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/repositories/models/municipal.dart';
import 'package:tahwisa/repositories/models/state.dart';

import 'drop_down_municipal_state.dart';

@immutable
abstract class DropDownMunicipalEvent extends Equatable {
  const DropDownMunicipalEvent();
  @override
  List<Object> get props => [];
}

class FetchMuniciaples extends DropDownMunicipalEvent {
  final MyState state;

  FetchMuniciaples({@required this.state});

  @override
  List<Object> get props => [state];
}

class MunicipalChosen extends DropDownMunicipalEvent {
  final Municipal municipal;
  const MunicipalChosen({
    @required this.municipal,
  });

  @override
  List<Object> get props => [municipal];

  @override
  String toString() => 'MunicipalChosen { municipal: $municipal }';
}

class LoadMunicipalState extends DropDownMunicipalEvent {
  final Municipal selectedMunicipal;
  final DropDownsMunicipalSuccess dropDownsMunicipalSuccess;
  const LoadMunicipalState({
    @required this.selectedMunicipal,
    @required this.dropDownsMunicipalSuccess,
  });

  @override
  List<Object> get props => [selectedMunicipal, dropDownsMunicipalSuccess];

  @override
  String toString() => 'Municipal Loaded { municipal: $selectedMunicipal }';
}

class ClearMunicipal extends DropDownMunicipalEvent {}
