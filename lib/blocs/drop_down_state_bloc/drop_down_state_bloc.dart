import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tahwisa/repositories/models/state.dart';

import '../drop_down_municipal_bloc/bloc.dart';
import 'bloc.dart';

class DropDownStateBloc extends Bloc<DropDownStateEvent, DropDownState> {
  final dropDownsRepository;
  final DropDownsMunicipalBloc municipalBloc;

  final _selectedState$ = BehaviorSubject<MyState>();
  Stream<MyState> get selectedState => _selectedState$;

  @override
  Future<void> close() {
    municipalBloc.close();
    _selectedState$.close();
    return super.close();
  }

  DropDownStateBloc(
      {@required this.dropDownsRepository, @required this.municipalBloc})
      : super(DropDownStateInitial());
  @override
  DropDownState get initialState => DropDownStateInitial();
  @override
  Stream<DropDownState> mapEventToState(
    DropDownStateEvent event,
  ) async* {
    if (event is FetchStates) {
      yield DropDownsStateLoading();
      try {
        final states = await dropDownsRepository.fetchStates();
        yield DropDownsStatesSuccess(states: states);
      } catch (error) {
        yield DropDownStateFailure(error: error.toString());
      }
    }
    if (event is StateChosen) {
      _selectedState$.add(event.state);
      municipalBloc.add(FetchMuniciaples(state: event.state));
    }
    if (event is ClearState) {
      _selectedState$.add(null);
      municipalBloc.add(ClearMunicipal());
    }
  }
}
