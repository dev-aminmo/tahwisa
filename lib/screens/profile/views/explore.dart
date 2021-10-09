import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/blocs/explore_places_bloc/bloc.dart';
import 'package:tahwisa/repositories/models/place.dart';
import 'package:tahwisa/repositories/place_repository.dart';
import 'package:tahwisa/screens/profile/widgets/place_card.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore>
    with AutomaticKeepAliveClientMixin<Explore> {
  bool _canLoadMore = true;
  ExplorePlacesBloc _explorePlacesBloc;
  final ScrollController _scrollController = ScrollController();
  PlaceRepository placeRepository;
  Future<void> refreshPlacesList(ExplorePlacesBloc bloc) async {
    bloc.add(FetchFirstPageExplorePlaces());
  }

  // Setting to true will force the tab to never be disposed.
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    placeRepository = RepositoryProvider.of<PlaceRepository>(context);
    _explorePlacesBloc = ExplorePlacesBloc(placeRepository: placeRepository)
      ..add(FetchFirstPageExplorePlaces());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              refreshPlacesList(context.read<ExplorePlacesBloc>());
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
                physics: BouncingScrollPhysics(),
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
      return SizedBox(
        child: Text('nothing'),
      );
    }
  }
}
