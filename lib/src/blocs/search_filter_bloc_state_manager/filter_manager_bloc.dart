import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tahwisa/src/blocs/drop_down_municipal_bloc/bloc.dart';
import 'package:tahwisa/src/blocs/drop_down_state_bloc/bloc.dart';
import 'package:tahwisa/src/repositories/models/SearchFilter.dart';
import 'package:tahwisa/src/repositories/models/municipal.dart';
import 'package:tahwisa/src/repositories/models/state.dart';

part 'filter_manager_event.dart';
part 'filter_manager_state.dart';

class FilterManagerBloc extends Bloc<FilterManagerEvent, FilterManagerState> {
  FilterManagerBloc() : super(FilterManagerInitial());

  @override
  Stream<FilterManagerState> mapEventToState(
    FilterManagerEvent event,
  ) async* {
    if (event is SaveFilterState) {
      if (event.dropDownStateBloc!.state is DropDownsStatesSuccess) {
        if (event.dropDownsMunicipalBloc!.state is DropDownsMunicipalSuccess) {
          yield (FilterManagerLoadedState(
            dropDownsStatesSuccess:
                event.dropDownStateBloc!.state as DropDownsStatesSuccess?,
            selectedState: event.dropDownStateBloc!.currentState,
            dropDownsMunicipalSuccess: event.dropDownsMunicipalBloc!.state
                as DropDownsMunicipalSuccess?,
            selectedMunicipal: event.dropDownsMunicipalBloc!.currentMunicipal,
            ratingRangeValues: event.ratingRangeValues,
          ));
        } else {
          yield (FilterManagerLoadedState(
            dropDownsStatesSuccess:
                event.dropDownStateBloc!.state as DropDownsStatesSuccess?,
            selectedState: event.dropDownStateBloc!.currentState,
            ratingRangeValues: event.ratingRangeValues,
          ));
        }
      } else {
        yield (FilterManagerLoadedState(
          ratingRangeValues: event.ratingRangeValues,
        ));
      }
    }
    if (event is ClearFilterState) {
      yield (FilterManagerInitial());
    }
  }

  SearchFilter stateToFilter() {
    if (state is FilterManagerLoadedState) {
      return SearchFilter(
        municipalId: (state as FilterManagerLoadedState)
            .selectedMunicipal
            ?.id
            ?.toString(),
        stateId:
            (state as FilterManagerLoadedState).selectedState?.id?.toString(),
        ratingMin: double.parse((state as FilterManagerLoadedState)
                .ratingRangeValues
                ?.start
                .toStringAsFixed(1) ??
            "0"),
        ratingMax: double.parse((state as FilterManagerLoadedState)
                .ratingRangeValues
                ?.end
                .toStringAsFixed(1) ??
            "5"),
      );
    } else {
      return SearchFilter();
    }
  }
}
