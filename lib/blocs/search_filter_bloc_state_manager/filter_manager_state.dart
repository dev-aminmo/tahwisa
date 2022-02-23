part of 'filter_manager_bloc.dart';

@immutable
abstract class FilterManagerState extends Equatable {
  @override
  List<Object> get props => [];
}

class FilterManagerInitial extends FilterManagerState {}

class FilterManagerLoadedState extends FilterManagerState {
  final DropDownsStatesSuccess? dropDownsStatesSuccess;
  final MyState? selectedState;
  final DropDownsMunicipalSuccess? dropDownsMunicipalSuccess;
  final Municipal? selectedMunicipal;
  final RangeValues? ratingRangeValues;

  FilterManagerLoadedState({
    this.dropDownsStatesSuccess,
    this.selectedState,
    this.dropDownsMunicipalSuccess,
    this.selectedMunicipal,
    required this.ratingRangeValues,
  });

  @override
  List<Object> get props => [
        dropDownsStatesSuccess!,
        selectedState!,
        dropDownsMunicipalSuccess!,
        selectedMunicipal!,
        ratingRangeValues!
      ];
}
