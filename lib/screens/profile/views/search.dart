import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/blocs/search_bloc/search_bloc.dart';
import 'package:tahwisa/cubits/search_query_cubit.dart';
import 'package:tahwisa/repositories/models/place.dart';
import 'package:tahwisa/repositories/place_repository.dart';
import 'package:tahwisa/repositories/tag_repository.dart';
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
  SearchBloc _searchBloc;
  SearchQueryCubit _searchQueryCubit;
  double width;
  double height;
  TextEditingController _searchEditingController;

  final ScrollController _scrollController = ScrollController();
  bool _canLoadMore = true;
  @override
  void initState() {
    super.initState();
    _searchEditingController = TextEditingController();
    placeRepository = RepositoryProvider.of<PlaceRepository>(context);
    _searchQueryCubit = SearchQueryCubit();
    TagRepository _tagRepository = TagRepository();

    _searchBloc = SearchBloc(
      placeRepository: placeRepository,
      searchQueryCubit: _searchQueryCubit,
      tagRepository: _tagRepository,
    )..add(FetchTags());
  }

  @override
  void dispose() {
    _searchEditingController.dispose();
    _scrollController.dispose();
    _searchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return HideKeyboardOnTap(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: NestedScrollView(
          floatHeaderSlivers: true,
          //     controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Container(
                padding:
                    EdgeInsets.only(top: height * 0.05, left: width * 0.02),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 25.0),
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
                            searchIconClicked: () {
                              _dismissKeyboard(context);
                              _addSearchFirstPageEvent();
                            },
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
                                  },
                                );
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
          body: BlocConsumer<SearchBloc, SearchState>(
              cubit: _searchBloc,
              listenWhen: (prev, next) {
                if (prev is SearchSuccess && next is SearchSuccess) {
                  return true;
                }
                return false;
              },
              listener: (prev, next) {
                print("consumerr called.........................");

                if (next is SearchSuccess) {
                  print("consumerr exuted.........................");
                  setState(() {
                    _canLoadMore = next.canLoadMore(_searchBloc.page);
                  });
                  print(_canLoadMore);
                }
              },
              builder: (context, state) {
                if (state is TagsFetched) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GridView.builder(
                        itemCount: state.tags.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            childAspectRatio: 1.4,
                            mainAxisSpacing: 16),
                        itemBuilder: (context, index) {
                          //  return Text("${state.tags[index].name}");
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    state.tags[index].picture,
                                  ),
                                  fit: BoxFit.cover,
                                )),
                            child: Center(
                                child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              color: Colors.black.withOpacity(0.05),
                              child: Text("${state.tags[index].name}",
                                  style: TextStyle(
                                      color: MyColors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                            )),
                          );
                        }),
                  );
                }
                if (state is SearchSuccess) {
                  _searchBloc..isFetching = false;

                  return StreamBuilder<List<Place>>(
                      stream: _searchBloc.places,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              controller: _scrollController
                                ..addListener(() {
                                  if ((_scrollController.offset ==
                                              _scrollController
                                                  .position.maxScrollExtent &&
                                          !_searchBloc.isFetching) &&
                                      _canLoadMore) {
                                    _searchBloc
                                      ..isFetching = true
                                      ..add(SearchPageRequested(state));
                                  }
                                }),
                              physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data.length + 1,
                              padding: const EdgeInsets.only(top: 8),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (ctx, index) {
                                if (index == snapshot.data.length) {
                                  return (_canLoadMore)
                                      ? Container(
                                          padding: const EdgeInsets.all(25),
                                          child: const Center(
                                              child:
                                                  CircularProgressIndicator()))
                                      : const SizedBox();
                                }
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
      ),
    );
  }

  BlocBuilder<SearchBloc, SearchState> _buildSearchTextField() {
    return BlocBuilder<SearchBloc, SearchState>(
        cubit: _searchBloc,
        builder: (context, state) => Expanded(
                child: SearchForPlacesTypeAheadField(
              searchEditingController: _searchEditingController,
              width: width,
              height: height,
              onEditingComplete: () {
                _dismissKeyboard(context);
                _addSearchFirstPageEvent();
              },
            )));
  }

  void _dismissKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void _addSearchFirstPageEvent() {
    //_searchQueryCubit.setQuery(_searchEditingController.text);
    _searchBloc.add(SearchFirstPageEvent(_searchEditingController.text));
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
