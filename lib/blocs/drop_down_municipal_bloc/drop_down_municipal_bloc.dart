import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tahwisa/repositories/models/municipal.dart';

import 'bloc.dart';

class DropDownsMunicipalBloc
    extends Bloc<DropDownMunicipalEvent, DropDownMunicipalState> {
  final dropDownsRepository;
  final _selectedMunicipal$ = BehaviorSubject<Municipal?>();

  void selectedStateEvent(Municipal? state) => _selectedMunicipal$.add(state);
  Stream<Municipal?> get selectedMunicipal => _selectedMunicipal$;
  Municipal? get currentMunicipal => _selectedMunicipal$.value;

  DropDownsMunicipalBloc({
    required this.dropDownsRepository,
  }) : super(DropDownMunicipalInitial()) {
    _selectedMunicipal$.add(null);
  }

  @override
  Stream<DropDownMunicipalState> mapEventToState(
    DropDownMunicipalEvent event,
  ) async* {
    if (event is FetchMuniciaples) {
      _selectedMunicipal$.add(null);

      yield DropDownsMunicipalLoading();
      try {
        final municipales =
            await dropDownsRepository.fetchMunicipales(stateId: event.state!.id);
        yield DropDownsMunicipalSuccess(municipales: municipales);
      } catch (error) {
        yield DropDownMunicipalFailure(error: error.toString());
      }
    }
    if (event is MunicipalChosen) {
      _selectedMunicipal$.add(event.municipal);
      // yield (DropDownsMunicipalChosen(municipal: event.municipal));
    }
    if (event is LoadMunicipalState) {
      _selectedMunicipal$.add(event.selectedMunicipal);

      yield event.dropDownsMunicipalSuccess!;
    }

    if (event is ClearMunicipal) {
      _selectedMunicipal$.add(null);
    }
  }
}
