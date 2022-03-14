import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/app/cubits/place_details_cubit/place_details_cubit.dart';
import 'package:tahwisa/app/cubits/reviews_cubit/reviews_cubit.dart';
import 'package:tahwisa/app/cubits/user_review_cubit/user_review_cubit.dart';
import 'package:tahwisa/app/cubits/wish_place_cubit/wish_place_cubit.dart';
import 'package:tahwisa/app/repositories/models/place.dart';
import 'package:tahwisa/app/repositories/place_repository.dart';
import 'package:tahwisa/app/repositories/review_repository.dart';
import 'package:tahwisa/app/screens/profile/widgets/place_details/widgets.dart';
import 'package:tahwisa/app/screens/profile/widgets/static_map_view.dart';
import 'package:tahwisa/app/style/my_colors.dart';

import 'LocationDisplayScreen.dart';

class PlaceDetailsScreen extends StatefulWidget {
  static const String routeName = '/place_details';

  static Route route(
      {Place? place, String? heroAnimationTag = "explore", var placeId}) {
    return MaterialPageRoute(
      builder: (_) => PlaceDetailsScreen(
          place: place, heroAnimationTag: heroAnimationTag, placeId: placeId),
      settings: RouteSettings(name: routeName),
    );
  }

  final Place? place;
  final String? heroAnimationTag;
  final placeId;
  const PlaceDetailsScreen({this.place, this.heroAnimationTag, this.placeId});

  @override
  _PlaceDetailsScreenState createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  late UserReviewCubit _userReviewCubit;
  ReviewRepository? _reviewRepository;
  PlaceDetailsCubit? _detailsCubit;

  @override
  void initState() {
    super.initState();
    if (widget.place != null) {
      _detailsCubit = PlaceDetailsCubit(
          place: widget.place,
          placeRepository: context.read<PlaceRepository>());
    } else {
      _detailsCubit = PlaceDetailsCubit(
          placeID: widget.placeId,
          placeRepository: context.read<PlaceRepository>());
    }
    _reviewRepository = context.read<ReviewRepository>();
    _userReviewCubit = UserReviewCubit(
        repository: _reviewRepository,
        placeID: widget.place?.id ?? widget.placeId);
  }

  @override
  void dispose() {
    _userReviewCubit.close();
    _detailsCubit!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      strokeWidth: 3,
      onRefresh: () async {
        _detailsCubit!.refresh();
      },
      child: Scaffold(
          appBar: buildAppBar(),
          extendBodyBehindAppBar: true,
          backgroundColor: MyColors.white,
          body: BlocBuilder(
            bloc: _detailsCubit,
            builder: (context, dynamic state) {
              if (state is PlaceDetailsSuccess) {
                return ListView(
                    padding: EdgeInsets.zero,
                    physics: ClampingScrollPhysics(),
                    children: [
                      Carousel(
                          place: state.place,
                          heroAnimationTag: widget.heroAnimationTag),
                      buildPlaceDetails(state.place!),
                    ] //]),
                    );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )),
    );
  }

  Padding buildPlaceDetails(Place place) {
    return Padding(
      padding: EdgeInsets.all(18),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleAndWishRow(
            title: place.title,
            wished: place.wished,
            placeId: place.id,
            wishPlaceCubit: context.read<WishPlaceCubit>(),
          ),
          const SizedBox(height: 20),
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => LocationDisplayScreen(
                              latitude: place.latitude,
                              longitude: place.longitude,
                              title: place.title,
                            )));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  LocationRow(place: place),
                  const SizedBox(height: 16),
                  StaticMapView(
                      latitude: place.latitude, longitude: place.longitude),
                ],
              )),
          const SizedBox(height: 16),
          const SizedBox(height: 16),
          Divider(
            indent: 32,
            endIndent: 32,
          ),
          const SizedBox(height: 8),
          Text(
            '@Uploaded by',
            style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8)),
          ),
          const SizedBox(height: 8),

          UserRow(place: place),
          const SizedBox(height: 8),

          const SizedBox(height: 8),

          DescriptionShowMoreText(text: place.description),
          const SizedBox(height: 8),
          TagsList(place: place),
          const SizedBox(height: 16),
          Divider(
            indent: 32,
            endIndent: 32,
          ),

          const SizedBox(height: 16),
          UserReviewBlocBuilder(userReviewCubit: _userReviewCubit),
          // const SizedBox(height: 32),
          const SizedBox(height: 8),
          Divider(
            indent: 32,
            endIndent: 32,
          ),

          Text(
            'Ratings and Reviews',
            style: TextStyle(fontSize: 22, color: Colors.grey.withOpacity(0.8)),
          ),

          const SizedBox(height: 16),
          ReviewsCountDisplay(place: place),
          BlocProvider<ReviewsCubit>(
            create: (_) =>
                ReviewsCubit(repository: _reviewRepository, placeID: place.id),
            child: ReviewBlocBuilder(),
          )
          //    ReviewBlocBuilder(reviewCubit: _userReviewCubit),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }
}
