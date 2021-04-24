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

class _ExploreState extends State<Explore> {
  bool _hasMore = true;
  Future<void> getData(ExplorePlacesBloc bloc) async {
    bloc.add(PlaceFetched(refresh: true));
  }

  final List<Place> _places = [];
  final ScrollController _scrollController = ScrollController();
  PlaceRepository placeRepository;

  @override
  void initState() {
    super.initState();
    //todo
    //scrollController.position.maxScrollExtent == scrollController.offset
    placeRepository = RepositoryProvider.of<PlaceRepository>(context);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (_) => ExplorePlacesBloc(placeRepository: placeRepository)
        ..add(PlaceFetched()),
      child: BlocConsumer<ExplorePlacesBloc, ExplorePlacesState>(
        listener: (context, state) {
          if (state is ExplorePlacesEmpty) {
            setState(() {
              _hasMore = false;
            });
          }
        },
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
                getData(context.read<ExplorePlacesBloc>());
              },
              child: child(
                  state, height, width, context.read<ExplorePlacesBloc>()));
        },
      ),
    );
  }

  Widget child(state, height, width, bloc) {
    if (_places.isEmpty && state is ExplorePlacesProgress) {
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
            if (!_hasMore) {
              return Center(
                child: Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 60),
                    height: 60,
                    width: 300,
                    color: Colors.black12,
                    child: Center(child: Text("No more places"))),
              );
            } else
              return Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 40),
                  child: Center(child: CircularProgressIndicator()));
          }
          return PlaceCard(
            height: height,
            width: width,
            index: index,
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
