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

  final _places$ = BehaviorSubject<List<Place>>();
  Stream<List<Place>> get places => _places$;
  final _places = <Place>[];

  @override
  Future<Function> close() {
    _places$.close();
  }

  SearchBloc({@required this.placeRepository})
      : assert(placeRepository != null),
        super(SearchInitial());

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchFirstPageEvent) {
      // final x = await placeRepository.search(event.query);
      final api_places =
          await placeRepository.fetchPlaces(int.parse(event.query));
      _places.addAll(api_places);
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
