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
  final List<Place> _places = [];
  final ScrollController _scrollController = ScrollController();
  PlaceRepository placeRepository;
  Future<void> refreshPlacesList(ExplorePlacesBloc bloc) async {
    _places.clear();
    bloc.add(PlaceFetched(refresh: true));
  }

  // Setting to true will force the tab to never be disposed.
  @override
  bool get wantKeepAlive => true;
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (_) => ExplorePlacesBloc(placeRepository: placeRepository)
        ..add(PlaceFetched()),
      child: BlocBuilder<ExplorePlacesBloc, ExplorePlacesState>(
        buildWhen: (previousState, currentState) {
          if (currentState is ExplorePlacesEmpty) {
            return false;
          } else
            return true;
        },
        builder: (context, state) {
          return RefreshIndicator(
              strokeWidth: 3,
              onRefresh: () async {
                refreshPlacesList(context.read<ExplorePlacesBloc>());
              },
              child: child(
                  state, height, width, context.read<ExplorePlacesBloc>()));
        },
      ),
    );
  }

  Widget child(state, height, width, bloc) {
    if (state is ExplorePlacesProgress) {
      return Center(child: CircularProgressIndicator());
    }
    if (state is ExplorePlacesEmpty) {
      return Center(
        child: Container(
            height: 60,
            width: 300,
            color: Colors.black12,
            child: Center(child: Text("No more places"))),
      );
    }
    if (state is ExplorePlacesSuccess) {
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
          );
        },
      );
    } else {
      return SizedBox(
        child: Text('nothing'),
      );
    }
  }
}
