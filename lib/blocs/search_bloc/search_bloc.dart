import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tahwisa/repositories/models/place.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final placeRepository;
  final searchQueryCubit;

  final _places$ = BehaviorSubject<List<Place>>();
  Stream<List<Place>> get places => _places$;
  final _places = <Place>[];

  @override
  Future<Function> close() {
    _places$.close();
  }

  SearchBloc({
    @required this.placeRepository,
    @required this.searchQueryCubit,
  })  : assert(placeRepository != null),
        super(SearchInitial());

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchFirstPageEvent) {
      final searchResult = await placeRepository.search(searchQueryCubit.state);
      _places.addAll(searchResult);
      //Short hand to avoid duplicates
      _places$.add([
        ...{..._places}
      ]);
      //if (places.length == 0) {
      yield SearchEmpty();
      //  } else {
      //     yield SearchSuccess(places: places);
      //   }
    }
  }
}
