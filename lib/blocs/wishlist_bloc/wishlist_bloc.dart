import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tahwisa/repositories/place_repository.dart';

import 'bloc.dart';

class WishListBloc extends Bloc<WishListEvent, WishListState> {
  final PlaceRepository placeRepository;
  int page = 1;
  bool isFetching = false;
  WishListBloc({@required this.placeRepository})
      : assert(placeRepository != null),
        super(WishListInitial());
  @override
  Stream<WishListState> mapEventToState(
    WishListEvent event,
  ) async* {
    if (event is PlaceFetched) {
      if (event.refresh) page = 1;
      if (page == 1) {
        yield WishListProgress();
      }
      try {
        final places = await placeRepository.fetchWishListPlaces(page);
        if (places.length == 0) {
          yield WishListEmpty();
        } else {
          page++;
          yield WishListSuccess(places: places);
        }
      } catch (error) {
        yield WishListFailure(error: error.toString());
      }
    }
    if (event is AddToWishList) {
      try {
        var response =
            await placeRepository.addToWishList(placeId: event.placeId);
        if (response) {
          yield (AddedToWishListSuccess());
          add(PlaceFetched(refresh: true));
        } else {
          yield (WishListFailure(error: "An error occurred"));
        }
      } catch (error) {
        yield (WishListFailure(error: error));
      }
    }
    if (event is RemoveFromWishList) {
      try {
        var response =
            await placeRepository.deleteFromWishList(placeId: event.placeId);
        if (response) {
          yield (RemovedFromWishListSuccess());
          add(PlaceFetched(refresh: true));
        } else {
          yield (WishListFailure(error: "An error occurred"));
        }
      } catch (error) {
        yield (WishListFailure(error: error));
      }
    }
  }
}
