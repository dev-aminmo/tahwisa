import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/blocs/search_bloc/search_bloc.dart';
import 'package:tahwisa/repositories/place_repository.dart';
import 'package:tahwisa/screens/profile/widgets/hide_keyboard_ontap.dart';
import 'package:tahwisa/screens/profile/widgets/place_card.dart';
import 'package:tahwisa/screens/profile/widgets/search/search_for_places_type_ahead_field.dart';
import 'package:tahwisa/style/my_colors.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  PlaceRepository placeRepository;

  double width;
  double height;
  TextEditingController _searchEditingController;
  @override
  void initState() {
    super.initState();
    _searchEditingController = TextEditingController();
    placeRepository = RepositoryProvider.of<PlaceRepository>(context);
  }

  @override
  void dispose() {
    _searchEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return HideKeyboardOnTap(
      child: BlocProvider(
        lazy: false,
        create: (_) => SearchBloc(placeRepository: placeRepository),
        child: ListView(
          children: [
            SizedBox(height: height * 0.05),
            Container(
              margin: EdgeInsets.only(left: width * 0.02),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, state) {
                      return SearchForPlacesTypeAheadField(
                        searchEditingController: _searchEditingController,
                        width: width,
                        height: height,
                        onEditingComplete: () {
                          context
                              .read<SearchBloc>()
                              .add(SearchFirstPageEvent(query: 'tout va'));
                        },
                      );
                    },
                  )),
                  RoundedSearchIcon(
                    searchIconClicked: () {},
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: width * 0.05, vertical: height * 0.025),
              child: Row(
                children: [
                  Text("14 places found",
                      style: TextStyle(
                        color: MyColors.darkBlue,
                      )),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Row(
                    children: [
                      Text("Filters",
                          style: TextStyle(
                            color: MyColors.darkBlue,
                          )),
                      Icon(
                        Icons.filter_list_sharp,
                        color: MyColors.lightGreen,
                      )
                    ],
                  )
                ],
              ),
            ),
            BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
              if (state is SearchSuccess) {
                return SingleChildScrollView(
                  child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.places.length,
                    itemBuilder: (ctx, index) {
                      return PlaceCard(
                        height: height,
                        width: width,
                        index: index,
                        place: state.places[index],
                      );

                      return Text("Helllo index $index");
                    },
                  ),
                );
              } else {
                return Center(child: Text("Nothing here"));
              }
            })
          ],
        ),
      ),
    );
  }
}

class RoundedSearchIcon extends StatelessWidget {
  const RoundedSearchIcon({
    this.searchIconClicked,
  });
  final searchIconClicked;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: searchIconClicked,
      padding: EdgeInsets.all(12),
      fillColor: MyColors.lightGreen,
      child: Icon(Icons.search, color: Colors.white),
      shape: CircleBorder(),
    );
  }
}
