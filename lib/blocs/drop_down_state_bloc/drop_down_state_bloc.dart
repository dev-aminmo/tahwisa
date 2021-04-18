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
//  Future<List<MyState>> states;
  Stream<MyState> get selectedState => _selectedState$;

  @override
  Future<Function> close() {
    municipalBloc.close();
    _selectedState$.close();
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
      /*try {
        dynamic municipales =
        await dropDownsRepository.fetchMunicipales(stateId: event.state.id);
        yield DropDownsMunicipalesSuccess(municipales: municipales);
      } catch (error) {
        yield DropDownsFailure(
            when: "Municipales Failure", error: error.toString());
      }*/
    }
  }
}
