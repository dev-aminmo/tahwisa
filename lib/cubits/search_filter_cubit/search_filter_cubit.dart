import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tahwisa/repositories/models/SearchFilter.dart';
import 'package:tahwisa/repositories/models/municipal.dart';
import 'package:tahwisa/repositories/models/state.dart';

part 'search_filter_state.dart';

class SearchFilterCubit extends Cubit<SearchFilterState> {
  StreamSubscription _selectedStateSubscription;
  StreamSubscription _selectedMunicipalSubscription;
  SearchFilterCubit({
    @required Stream<MyState> selectedState,
    @required Stream<Municipal> selectedMunicipal,
  }) : super(SearchFilterInitial()) {
    _monitorSelectedState(selectedState);
    _monitorSelectedMunicipal(selectedMunicipal);
  }

  void _monitorSelectedMunicipal(Stream<Municipal> selectedMunicipal) {
    _selectedMunicipalSubscription = selectedMunicipal.listen((event) {
      if (state is FilterLoadedState) {
        setFilter(((state) as FilterLoadedState)
            .filter
            .copyWith(municipalId: '' ?? event?.id.toString()));
      } else {
        setFilter(SearchFilter(municipalId: '' ?? event?.id.toString()));
      }
    });
  }

  void _monitorSelectedState(Stream<MyState> selectedState) {
    _selectedStateSubscription = selectedState.listen((event) {
      if (state is FilterLoadedState) {
        setFilter(((state) as FilterLoadedState)
            .filter
            .copyWith(stateId: '' ?? event?.id.toString()));
      } else {
        setFilter(SearchFilter(stateId: '' ?? event?.id.toString()));
      }
    });
  }

  void setFilter(SearchFilter searchFilter) {
    emit(FilterLoadedState(searchFilter));
    print(searchFilter);
  }

  void setRangeValues(SearchFilter searchFilter) {
    emit(FilterLoadedState(searchFilter));
  }

  void clearFilter() {
    emit(SearchFilterInitial());
  }

  @override
  Future<Function> close() {
    _selectedStateSubscription.cancel();
    _selectedMunicipalSubscription.cancel();
    return super.close();
  }
}
