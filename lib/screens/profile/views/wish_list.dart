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
  final List<Place> _places = [];
  final ScrollController _scrollController = ScrollController();
  PlaceRepository placeRepository;

  Future<void> getData(WishListBloc bloc) async {
    _places.clear();
    bloc.add(PlaceFetched(refresh: true));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (_) =>
          WishListBloc(placeRepository: placeRepository)..add(PlaceFetched()),
      child: BlocBuilder<WishListBloc, WishListState>(
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
                getData(context.read<WishListBloc>());
              },
              child: child(state, height, width, context.read<WishListBloc>()));
        },
      ),
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
      bloc..isFetching = false;
      _places.addAll(state.places);
      return ListView.builder(
        controller: _scrollController
          ..addListener(() {
            if (_scrollController.offset ==
                    _scrollController.position.maxScrollExtent &&
                !bloc.isFetching) {
              bloc
                ..isFetching = true
                ..add(PlaceFetched());
            }
          }),
        itemCount: _places.length + 1,
        itemBuilder: (ctx, index) {
          if (index == _places.length) {
            return Container(
              margin: const EdgeInsets.only(top: 20, bottom: 60),
              height: 60,
              width: 300,
            );
          }
          return PlaceCard(
            width: width,
            callback: () {},
            place: _places[index],
            heroAnimationTag: 'wish',
          );
        },
      );
    } else {
      return SizedBox(
        child: Text('nothing'),
      );
    }
  }

  /*@override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    */ /*return ListView.builder(
      itemCount: 20,
      itemBuilder: (ctx, index) {
        return WishCard(
          height: height,
          width: width,
          index: index,
        );
      },
    );
    */ /*

  }*/
  @override
  void initState() {
    super.initState();
    //scrollController.position.maxScrollExtent == scrollController.offset
    placeRepository = RepositoryProvider.of<PlaceRepository>(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
