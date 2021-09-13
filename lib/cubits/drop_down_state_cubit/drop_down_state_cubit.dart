import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tahwisa/blocs/drop_down_municipal_bloc/bloc.dart';
import 'package:tahwisa/repositories/models/state.dart';

part 'drop_down_state_state.dart';

class DropDownStateCubit extends Cubit<DropDownStateState> {
  final dropDownsRepository;
  final DropDownsMunicipalBloc municipalBloc;

  final _selectedState$ = BehaviorSubject<MyState>();
  Stream<MyState> get selectedState => _selectedState$;

  @override
  Future<Function> close() {
    _selectedState$.close();
    super.close();
  }

  DropDownStateCubit(
      {@required this.dropDownsRepository, @required this.municipalBloc})
      : super(DropDownStateInitial()) {
    fetchStates();
  }

  void fetchStates() async {
    try {
      emit(DropDownStateLoadingState());
      final states = await dropDownsRepository.fetchStates();
      emit(DropDownStateLoadedState(states));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void selectState(MyState state) async {
    try {
      _selectedState$.add(state);
      municipalBloc.add(FetchMuniciaples(state:state));
    } catch (e) {
      emit(ErrorState());
    }
  }
}
