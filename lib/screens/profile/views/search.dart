import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/blocs/search_bloc/search_bloc.dart';
import 'package:tahwisa/repositories/models/place.dart';
import 'package:tahwisa/repositories/place_repository.dart';
import 'package:tahwisa/screens/profile/widgets/hide_keyboard_ontap.dart';
import 'package:tahwisa/screens/profile/widgets/place_card.dart';
import 'package:tahwisa/screens/profile/widgets/search/filters_screen.dart';
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

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _searchEditingController = TextEditingController();
    placeRepository = RepositoryProvider.of<PlaceRepository>(context);
  }

  @override
  void dispose() {
    _searchEditingController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return HideKeyboardOnTap(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: BlocProvider(
            lazy: false,
            create: (_) => SearchBloc(placeRepository: placeRepository),
            child: NestedScrollView(
              floatHeaderSlivers: true,
              controller: _scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: Container(
                    padding:
                        EdgeInsets.only(top: height * 0.05, left: width * 0.02),
                    decoration: BoxDecoration(
                      // color: Colors.grey.withOpacity(0.2),
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(38.0),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            offset: const Offset(0, 2),
                            blurRadius: 8.0),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildSearchTextField(),
                              RoundedSearchIcon(
                                searchIconClicked: () {},
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: width * 0.05,
                              vertical: height * 0.025),
                          child: Row(
                            children: [
                              Text("14 places found",
                                  style: TextStyle(
                                    color: MyColors.darkBlue,
                                  )),
                              Expanded(
                                child: SizedBox(),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  focusColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.grey.withOpacity(0.2),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(4.0),
                                  ),
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    showModalBottomSheet<void>(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return FiltersScreen();
                                        /* return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            */
                                        /*
                                            const SizedBox(
                                              height: 100,
                                            ),
                                            const Text('Modal BottomSheet'),
                                            const SizedBox(
                                              height: 100,
                                            ),*/
                                        /*
                                            FiltersScreen(),
                                            ElevatedButton(
                                              child: const Text(
                                                  'Close BottomSheet'),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                          ],
                                        );*/
                                      },
                                    );
                                    /*   showModalBottomSheet<void>(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(25))),
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return FiltersScreen();
                                        */ /* return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            */ /*
                                        */ /*
                                            const SizedBox(
                                              height: 100,
                                            ),
                                            const Text('Modal BottomSheet'),
                                            const SizedBox(
                                              height: 100,
                                            ),*/ /*
                                        */ /*
                                            FiltersScreen(),
                                            ElevatedButton(
                                              child: const Text(
                                                  'Close BottomSheet'),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                          ],
                                        );*/ /*
                                      },
                                    );*/
                                    /*    Navigator.push<dynamic>(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                          builder: (BuildContext context) =>
                                              FiltersScreen(),
                                          fullscreenDialog: true),
                                    );*/
                                  },
                                  child: Row(
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
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
              body: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                if (state is SearchEmpty) {
                  return StreamBuilder<List<Place>>(
                      stream: context.read<SearchBloc>().places,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              // physics: ClampingScrollPhysics(),
                              physics: BouncingScrollPhysics(),
                              // shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              /*
                            itemBuilder: (ctx, index) => PlaceCard(
                              place: snapshot.data[index],
                              height: height,
                              width: width,
                              index: index,
                            ),*/
                              padding: const EdgeInsets.only(top: 8),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (ctx, index) {
                                return PlaceCard(
                                  place: snapshot.data[index],
                                  callback: () {},
                                  width: width,
                                );
                              });
                        }
                        return Container(
                          height: 100,
                          color: Colors.red,
                          child: Text(
                            "State 1",
                          ),
                        );
                      });
                } else {
                  return Container(
                      height: 100,
                      child: Text(
                        "State 0",
                      ));
                }
              }),
            ),
          )),
    );
  }

  BlocBuilder<SearchBloc, SearchState> _buildSearchTextField() {
    return BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) => Expanded(
                child: SearchForPlacesTypeAheadField(
              searchEditingController: _searchEditingController,
              width: width,
              height: height,
              onEditingComplete: () {
                _dismissKeyboard(context);
                // context.read<SearchBloc>().add(SearchFirstPageEvent(query: _searchEditingController.text));
              },
            )));
  }

  void _dismissKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
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
