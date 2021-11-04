import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/repositories/models/municipal.dart';

@immutable
abstract class DropDownMunicipalState extends Equatable {
  const DropDownMunicipalState();
  @override
  List<Object> get props => [];
}

class DropDownMunicipalInitial extends DropDownMunicipalState {}

class DropDownsMunicipalLoading extends DropDownMunicipalState {}

class DropDownsMunicipalSuccess extends DropDownMunicipalState {
  final List<Municipal> municipales;
  DropDownsMunicipalSuccess({this.municipales});

  @override
  List<Object> get props => [municipales];
}

class DropDownMunicipalFailure extends DropDownMunicipalState {
  final String error;

  const DropDownMunicipalFailure({
    @required this.error,
  });

  @override
  List<Object> get props => [error];

  @override
  String toString() => ' { error: $error }';
}
