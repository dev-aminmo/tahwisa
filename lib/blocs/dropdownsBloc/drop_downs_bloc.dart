import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tahwisa/repositories/models/municipal.dart';
import 'package:tahwisa/repositories/models/state.dart';

class DropDownStateBloc extends Bloc<DropDownStateEvent, DropDownState> {
  final dropDownsRepository;
  final DropDownsMunicipalBloc municipalBloc;

  final _selectedState$ = BehaviorSubject<MyState>();
//  Future<List<MyState>> states;
  Stream<MyState> get selectedState => _selectedState$;

  @override
  Future<Function> close() {
    municipalBloc.close();
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

class DropDownsMunicipalBloc
    extends Bloc<DropDownMunicipalEvent, DropDownMunicipal> {
  final dropDownsRepository;
  final _selectedMunicipal$ = BehaviorSubject<Municipal>();
  void selectedStateEvent(Municipal state) => _selectedMunicipal$.add(state);
//  Future<List<MyState>> states;
  Stream<Municipal> get selectedMunicipal => _selectedMunicipal$;
  DropDownsMunicipalBloc({
    @required this.dropDownsRepository,
  }) : super(DropDownMunicipalInitial()) {
    _selectedMunicipal$.add(null);
  }
  @override
  DropDownMunicipal get initialState => DropDownMunicipalInitial();

  @override
  Stream<DropDownMunicipal> mapEventToState(
    DropDownMunicipalEvent event,
  ) async* {
    if (event is FetchMuniciaples) {
      _selectedMunicipal$.add(null);

      yield DropDownsMunicipalLoading();
      try {
        final municipales =
            await dropDownsRepository.fetchMunicipales(stateId: event.state.id);
        yield DropDownsMunicipalSuccess(municipales: municipales);
      } catch (error) {
        yield DropDownMunicipalFailure(error: error.toString());
      }
    }
    if (event is MunicipalChosen) {
      _selectedMunicipal$.add(event.municipal);
    }
  }
}

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

@immutable
abstract class DropDownMunicipalEvent extends Equatable {
  const DropDownMunicipalEvent();
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

@immutable
abstract class DropDownState extends Equatable {
  const DropDownState();
  @override
  List<Object> get props => [];
}

class DropDownStateInitial extends DropDownState {}

class DropDownsStateLoading extends DropDownState {}

class DropDownsStatesSuccess extends DropDownState {
  final List<MyState> states;
  DropDownsStatesSuccess({this.states});
  @override
  List<Object> get props => [states];
}

class DropDownStateFailure extends DropDownState {
  final String error;

  const DropDownStateFailure({
    @required this.error,
  });

  @override
  List<Object> get props => [error];

  @override
  String toString() => ' { error: $error }';
}

@immutable
abstract class DropDownMunicipal extends Equatable {
  const DropDownMunicipal();
  @override
  List<Object> get props => [];
}

class DropDownMunicipalInitial extends DropDownMunicipal {}

class DropDownsMunicipalLoading extends DropDownMunicipal {}

class DropDownsMunicipalSuccess extends DropDownMunicipal {
  final List<Municipal> municipales;
  DropDownsMunicipalSuccess({this.municipales});

  @override
  List<Object> get props => [municipales];
}

class DropDownMunicipalFailure extends DropDownMunicipal {
  final String error;

  const DropDownMunicipalFailure({
    @required this.error,
  });

  @override
  List<Object> get props => [error];

  @override
  String toString() => ' { error: $error }';
}
