import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/src/blocs/explore_places_bloc/bloc.dart';
import 'package:tahwisa/src/cubits/wish_place_cubit/wish_place_cubit.dart';
import 'package:tahwisa/src/repositories/models/place.dart';
import 'package:tahwisa/src/repositories/place_repository.dart';
import 'package:tahwisa/src/screens/profile/widgets/place_card.dart';
import 'package:tahwisa/src/style/my_colors.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore>
    with AutomaticKeepAliveClientMixin<Explore> {
  bool _canLoadMore = true;
  late ExplorePlacesBloc _explorePlacesBloc;
  final ScrollController _scrollController = ScrollController();
  PlaceRepository? placeRepository;
  Future<void> refreshPlacesList() async {
    _explorePlacesBloc.add(FetchFirstPageExplorePlaces());
  }

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    placeRepository = RepositoryProvider.of<PlaceRepository>(context);
    _explorePlacesBloc = ExplorePlacesBloc(
        placeRepository: placeRepository,
        wishPlaceCubit: context.read<WishPlaceCubit>());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocConsumer<ExplorePlacesBloc, ExplorePlacesState>(
      bloc: _explorePlacesBloc,
      listener: (context, state) {
        if (state is ExplorePlacesSuccess) {
          setState(() {
            _canLoadMore = state.canLoadMore(_explorePlacesBloc.page);
          });
        }
      },
      builder: (context, state) {
        return RefreshIndicator(
            strokeWidth: 3,
            onRefresh: () async {
              refreshPlacesList();
            },
            child: child(state, height, width));
      },
    );
  }

  Widget child(state, height, width) {
    if (state is ExplorePlacesProgress) {
      return Center(child: CircularProgressIndicator());
    }
    if (state is ExplorePlacesSuccess) {
      _explorePlacesBloc..isFetching = false;
      return StreamBuilder<List<Place>>(
          stream: _explorePlacesBloc.places,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                physics: AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                controller: _scrollController
                  ..addListener(() {
                    if ((_scrollController.offset ==
                                _scrollController.position.maxScrollExtent &&
                            !_explorePlacesBloc.isFetching) &&
                        _canLoadMore) {
                      _explorePlacesBloc
                        ..isFetching = true
                        ..add(FetchExplorePlacesPageRequested(state));
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
                    heroAnimationTag: 'explore',
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
      if (state is ExplorePlacesFailure) {
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
                  refreshPlacesList();
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
}
