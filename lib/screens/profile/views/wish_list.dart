import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/blocs/wishlist_bloc/bloc.dart';
import 'package:tahwisa/cubits/wish_place_cubit/wish_place_cubit.dart';
//import 'package:tahwisa/blocs/explore_places_bloc/bloc.dart';
import 'package:tahwisa/repositories/models/place.dart';
import 'package:tahwisa/repositories/place_repository.dart';
import 'package:tahwisa/screens/profile/widgets/place_card.dart';

class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList>
    with AutomaticKeepAliveClientMixin<WishList> {
  final ScrollController _scrollController = ScrollController();
  WishListBloc _wishListBloc;
  PlaceRepository placeRepository;
  bool _canLoadMore = true;

  Future<void> getData(WishListBloc bloc) async {
    bloc.add(FetchFirstPageWishList());
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocConsumer<WishListBloc, WishListState>(
      bloc: _wishListBloc,
      listener: (context, state) {
        if (state is WishListSuccess) {
          setState(() {
            _canLoadMore = state.canLoadMore(_wishListBloc.page);
          });
        }
      },
      builder: (context, state) {
        return RefreshIndicator(
            strokeWidth: 3,
            onRefresh: () async {
              getData(_wishListBloc);
            },
            child: child(state, height, width, _wishListBloc));
      },
    );
  }

  Widget child(state, height, width, bloc) {
    if (state is WishListProgress) {
      return Center(child: CircularProgressIndicator());
    }
    if (state is WishListEmpty) {
      return Center(
        child: Container(
            height: 60,
            width: 300,
            color: Colors.black12,
            child: Center(child: Text("No more places"))),
      );
    }
    if (state is WishListSuccess) {
      _wishListBloc..isFetching = false;
      return StreamBuilder<List<Place>>(
          stream: _wishListBloc.places,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                controller: _scrollController
                  ..addListener(() {
                    if ((_scrollController.offset ==
                                _scrollController.position.maxScrollExtent &&
                            !_wishListBloc.isFetching) &&
                        _canLoadMore) {
                      _wishListBloc
                        ..isFetching = true
                        ..add(FetchWishListPageRequested(state));
                    }
                  }),
                itemCount: snapshot.data.length + 1,
                itemBuilder: (ctx, index) {
                  if (index == snapshot.data.length) {
                    return (_canLoadMore)
                        ? Container(
                            padding: const EdgeInsets.all(25),
                            child: const Center(
                                child: CircularProgressIndicator()))
                        : const SizedBox();
                  }
                  return PlaceCard(
                    width: width,
                    callback: () {},
                    place: snapshot.data[index],
                    heroAnimationTag: 'wish',
                  );
                },
              );
            } else {
              return SizedBox(
                child: Text('nothing'),
              );
            }
          });
    } else {
      return SizedBox();
    }
  }

  @override
  void initState() {
    super.initState();
    placeRepository = RepositoryProvider.of<PlaceRepository>(context);
    _wishListBloc = WishListBloc(
        placeRepository: placeRepository,
        wishPlaceCubit: context.read<WishPlaceCubit>())
      ..add(FetchFirstPageWishList());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
