part of 'filter_manager_bloc.dart';

@immutable
abstract class FilterManagerEvent extends Equatable {
  const FilterManagerEvent();
  @override
  List<Object> get props => [];
}

class SaveFilterState extends FilterManagerEvent {
  final DropDownsMunicipalBloc? dropDownsMunicipalBloc;
  final DropDownStateBloc? dropDownStateBloc;
  final RangeValues? ratingRangeValues;

  SaveFilterState({
    required this.dropDownsMunicipalBloc,
    required this.dropDownStateBloc,
    required this.ratingRangeValues,
  });

  @override
  get props => [
        dropDownsMunicipalBloc!,
        dropDownStateBloc!,
      //  ratingRangeValues?.start,
       // ratingRangeValues?.end
      ];

  @override
  String toString() =>
      'DropDownStateBloc { state: $dropDownStateBloc } ,DropDownsMunicipalBloc { state: $dropDownsMunicipalBloc ,ratingRangeValues { state: $ratingRangeValues }';
}

class ClearFilterState extends FilterManagerEvent {}
