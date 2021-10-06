import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/blocs/wishlist_bloc/bloc.dart';
//import 'package:tahwisa/blocs/explore_places_bloc/bloc.dart';
import 'package:tahwisa/repositories/models/place.dart';
import 'package:tahwisa/repositories/place_repository.dart';
import 'package:tahwisa/screens/profile/widgets/place_card.dart';

class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  final ScrollController _scrollController = ScrollController();
  WishListBloc _wishListBloc;
  PlaceRepository placeRepository;

  Future<void> getData(WishListBloc bloc) async {
    bloc.add(FetchFirstPageWishList());
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocBuilder<WishListBloc, WishListState>(
      bloc: _wishListBloc,
      buildWhen: (previousState, currentState) {
        if (currentState is WishListEmpty) {
          return false;
        } else
          return true;
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
      return StreamBuilder<List<Place>>(
          stream: _wishListBloc.places,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                controller: _scrollController
                  ..addListener(() {
                    /*
            if (_scrollController.offset ==
                    _scrollController.position.maxScrollExtent &&
                !bloc.isFetching) {
              bloc
                ..isFetching = true
                ..add(PlaceFetched());
            }*/
                  }),
                itemCount: snapshot.data.length + 1,
                itemBuilder: (ctx, index) {
                  if (index == snapshot.data.length) {
                    return Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 60),
                      height: 60,
                      width: 300,
                    );
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
    _wishListBloc = WishListBloc(placeRepository: placeRepository)
      ..add(FetchFirstPageWishList());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
