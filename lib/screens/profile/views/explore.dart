import 'package:flutter/material.dart';
import 'package:tahwisa/screens/profile/widgets/place_card.dart';
import 'package:tahwisa/style/my_colors.dart';
import 'package:tahwisa/blocs/explore_places_bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/repositories/place_repository.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (_) => ExplorePlacesBloc(placeRepository: PlaceRepository())
        ..add(PlaceFetched()),
      child: BlocBuilder<ExplorePlacesBloc, ExplorePlacesState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: 20,
            itemBuilder: (ctx, index) {
              return PlaceCard(
                height: height,
                width: width,
                index: index,
              );
            },
          );
        },
      ),
    );
  }
}
