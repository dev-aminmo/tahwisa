import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/src/blocs/search_bloc/search_bloc.dart';
import 'package:tahwisa/src/blocs/search_filter_bloc_state_manager/filter_manager_bloc.dart';
import 'package:tahwisa/src/cubits/top_tags_cubit/top_tags_cubit.dart';
import 'package:tahwisa/src/cubits/wish_place_cubit/wish_place_cubit.dart';
import 'package:tahwisa/src/repositories/models/place.dart';
import 'package:tahwisa/src/repositories/models/tag.dart';
import 'package:tahwisa/src/repositories/place_repository.dart';
import 'package:tahwisa/src/repositories/tag_repository.dart';
import 'package:tahwisa/src/screens/profile/widgets/hide_keyboard_ontap.dart';
import 'package:tahwisa/src/screens/profile/widgets/place_card.dart';
import 'package:tahwisa/src/screens/profile/widgets/search/widgets.dart';
import 'package:tahwisa/src/style/my_colors.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late PlaceRepository placeRepository;
  late SearchBloc _searchBloc;
  double? width;
  double? height;
  TextEditingController? _searchEditingController;
  TopTagsCubit? _topTagsCubit;
  ScrollController? innerScrollController;
  late FilterManagerBloc _filterManagerBloc;

  bool _canLoadMore = true;
  @override
  void initState() {
    super.initState();
    _searchEditingController = TextEditingController();
    placeRepository = RepositoryProvider.of<PlaceRepository>(context);
    TagRepository _tagRepository = TagRepository();
    _topTagsCubit = TopTagsCubit(repository: _tagRepository);
    _filterManagerBloc = FilterManagerBloc();
    _searchBloc = SearchBloc(
        filterManagerBloc: _filterManagerBloc,
        placeRepository: placeRepository,
        tagRepository: _tagRepository,
        wishPlaceCubit: context.read<WishPlaceCubit>());
  }

  @override
  void dispose() {
    _searchEditingController!.dispose();
    _searchBloc.close();
    _filterManagerBloc.close();
    innerScrollController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return HideKeyboardOnTap(
        child: SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocProvider.value(
          value: _searchBloc,
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) =>
                [buildSliverAppBar(context)],
            body: BlocConsumer<SearchBloc, SearchState>(
                //      cubit: _searchBloc,
                listenWhen: (prev, next) {
              if (next is SearchSuccess) {
                return true;
              }
              return false;
            }, listener: (context, state) {
              if (state is SearchSuccess) {
                setState(() {
                  _canLoadMore = state.canLoadMore(_searchBloc.page);
                });
              }
            }, builder: (context, state) {
              final innerScrollController = PrimaryScrollController.of(context);
              if (state is SearchInitial) {
                return TopTagsView(topTagsCubit: _topTagsCubit);
              }
              if (state is SearchProgress) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is SearchSuccess) {
                _searchBloc..isFetching = false;
                return StreamBuilder<List<Place>>(
                    stream: _searchBloc.places,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.length == 0) {
                          return Center(
                            child:
                                Stack(alignment: Alignment.center, children: [
                              Image.asset('assets/images/empty-search.gif'),
                              Positioned(
                                  bottom: 32,
                                  child: Center(
                                    child: Text('No places was found',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: MyColors.darkBlue,
                                          fontSize: 16,
                                        )),
                                  ))
                            ]),
                          );
                        }
                        return ListView.builder(
                            controller: innerScrollController!
                              ..addListener(() {
                                if ((innerScrollController.offset ==
                                            innerScrollController
                                                .position.maxScrollExtent &&
                                        _searchBloc.isFetching) &&
                                    _canLoadMore) {
                                  _searchBloc
                                    ..isFetching = true
                                    ..add(SearchPageRequested(state));
                                }
                              }),
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data!.length + 1,
                            padding: const EdgeInsets.only(top: 8),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (ctx, index) {
                              if (index == snapshot.data!.length) {
                                return (_canLoadMore)
                                    ? Container(
                                        padding: const EdgeInsets.all(25),
                                        child: const Center(
                                            child: CircularProgressIndicator()))
                                    : const SizedBox();
                              }
                              if ((index == 0) && (state.tag?.name != null)) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width! * 0.025,
                                          vertical: 8),
                                      child: FittedBox(
                                        child: Text("#${state.tag!.name}",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 36,
                                                color: MyColors.darkBlue)),
                                      ),
                                    ),
                                    PlaceCard(
                                      place: snapshot.data![index],
                                      heroAnimationTag: 'search',
                                      callback: () {},
                                      width: width,
                                    ),
                                  ],
                                );
                              }
                              return PlaceCard(
                                place: snapshot.data![index],
                                heroAnimationTag: 'search',
                                callback: () {},
                                width: width,
                              );
                            });
                      }
                      return SizedBox();
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
      ),
    ));
  }

  SliverToBoxAdapter buildSliverAppBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(top: height! * 0.02, left: width! * 0.02),
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
                  RoundedSearchButton(
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
                  horizontal: width! * 0.05, vertical: height! * 0.025),
              child: Row(
                children: [
                  BlocBuilder<SearchBloc, SearchState>(
                    bloc: _searchBloc,
                    builder: (context, state) {
                      if (state is SearchSuccess) {
                        return Text("${state.numResults} places found",
                            style: TextStyle(
                              color: MyColors.darkBlue,
                            ));
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
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
                        FocusScope.of(context).requestFocus(FocusNode());

                        showModalBottomSheet<void>(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return FiltersScreen(_filterManagerBloc);
                          },
                        ).then((value) {
                          _searchBloc.add(FilterUpdated());
                        });
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
    );
  }

  Widget _buildSearchTextField() {
    return BlocBuilder<SearchBloc, SearchState>(
        //cubit: _searchBloc,
        builder: (context, state) => Expanded(
                child: SearchForPlacesTypeAheadField(
              suggestionsCallback: (pattern) async {
                return (pattern.length > 1)
                    ? await placeRepository.autocomplete(pattern)
                    : [];
              },
              searchEditingController: _searchEditingController,
              width: width,
              height: height,
              onEditingComplete: () {
                _dismissKeyboard(context);
                _addSearchFirstPageEvent();
              },
              onSuggestionSelected: (suggestion) {
                if (suggestion is Tag) {
                  context.read<SearchBloc>().add(SearchFirstPageEvent(
                        query: '',
                        tag: suggestion,
                      ));
                }
                if (suggestion is Place) {
                  Navigator.pushNamed(
                    context,
                    '/place_details',
                    arguments: {
                      'placeId': suggestion.id,
                      'heroAnimationTag': 'heroAnimationTag',
                    },
                  );
                }
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
    _searchBloc
        .add(SearchFirstPageEvent(query: _searchEditingController!.text));
  }
}

class TopTagsView extends StatelessWidget {
  const TopTagsView({
    Key? key,
    required TopTagsCubit? topTagsCubit,
  })  : _topTagsCubit = topTagsCubit,
        super(key: key);

  final TopTagsCubit? _topTagsCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopTagsCubit, TopTagsState>(
      bloc: _topTagsCubit,
      builder: (context, state) {
        if (state is TagsLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is TagsLoadedState) {
          var tags = state.tags;
          return TopTagsGridView(tags: tags);
        }
        return SizedBox();
      },
    );
  }
}
