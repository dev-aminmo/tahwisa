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
  var _exploreBloc;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocBuilder<ExplorePlacesBloc, ExplorePlacesState>(
      cubit: _exploreBloc,
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              height: 400,
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (ctx, index) {
                  return PlaceCard(
                    height: height,
                    width: width,
                    index: index,
                  );
                },
              ),
            ),
            MaterialButton(
                onPressed: () {
                  print("haw shaho");
                  _exploreBloc.add(PlaceFetched());
                },
                color: Colors.pink,
                child: Text("como esta"))
          ],
        );
      },
    );
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
  }

  @override
  void initState() {
    super.initState();
    _exploreBloc = ExplorePlacesBloc(placeRepository: PlaceRepository());
  }
}
