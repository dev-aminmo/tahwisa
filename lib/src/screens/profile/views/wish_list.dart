import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tahwisa/src/blocs/wishlist_bloc/bloc.dart';
import 'package:tahwisa/src/cubits/wish_place_cubit/wish_place_cubit.dart';
import 'package:tahwisa/src/repositories/models/place.dart';
import 'package:tahwisa/src/repositories/place_repository.dart';
import 'package:tahwisa/src/screens/profile/widgets/place_card.dart';
import 'package:tahwisa/src/style/my_colors.dart';

class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList>
    with AutomaticKeepAliveClientMixin<WishList> {
  final ScrollController _scrollController = ScrollController();
  late WishListBloc _wishListBloc;
  PlaceRepository? placeRepository;
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
              if (snapshot.data!.length == 0) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.heartBroken,
                          size: 136, color: MyColors.greenBorder),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.03,
                        ),
                        child: FittedBox(
                          alignment: Alignment.center,
                          child: Text("Your wish list is empty",
                              style: TextStyle(
                                  color: MyColors.greenBorder, fontSize: 22)),
                        ),
                      )
                    ],
                  ),
                );
              }
              return ListView.builder(
                physics: AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
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
                itemCount: snapshot.data!.length + 1,
                itemBuilder: (ctx, index) {
                  if (index == snapshot.data!.length) {
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
                    place: snapshot.data![index],
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
      if (state is WishListFailure) {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.refresh_outlined,
                color: MyColors.greenBorder,
                size: 72,
              ),
              MaterialButton(
                color: MyColors.greenBorder,
                onPressed: () {
                  getData(_wishListBloc);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    "Re-Try",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Something wrong happened",
                style: TextStyle(color: MyColors.greenBorder, fontSize: 18),
              ),
            ],
          ),
        );
      }
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
