import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/repositories/models/place.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final placeRepository;

  SearchBloc({@required this.placeRepository})
      : assert(placeRepository != null),
        super(SearchInitial());

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchFirstPageEvent) {
      final places = await placeRepository.search(event.query);

      if (places.length == 0) {
        yield SearchEmpty();
      } else {
        yield SearchSuccess(places: places);
      }
    }
  }
}
