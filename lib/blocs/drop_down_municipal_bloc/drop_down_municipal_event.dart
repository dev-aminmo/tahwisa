import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/repositories/models/municipal.dart';
import 'package:tahwisa/repositories/models/state.dart';

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

class ClearMunicipal extends DropDownMunicipalEvent {}
