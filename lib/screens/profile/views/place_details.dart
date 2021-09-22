import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tahwisa/cubits/user_review_cubit/user_review_cubit.dart';
import 'package:tahwisa/repositories/models/place.dart';
import 'package:tahwisa/repositories/review_repository.dart';
import 'package:tahwisa/screens/profile/widgets/place_details/widgets.dart';
import 'package:tahwisa/style/my_colors.dart';

class PlaceDetailsScreen extends StatefulWidget {
  static const String routeName = '/place_details';

  static Route route(
      {@required Place place, String heroAnimationTag = "explore"}) {
    return MaterialPageRoute(
      builder: (_) => PlaceDetailsScreen(
        place: place,
        heroAnimationTag: heroAnimationTag,
      ),
      settings: RouteSettings(name: routeName),
    );
  }

  final Place place;
  final String heroAnimationTag;

  const PlaceDetailsScreen({@required this.place, this.heroAnimationTag});

  @override
  _PlaceDetailsScreenState createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  Place place;
  UserReviewCubit _userReviewCubit;
  @override
  void initState() {
    super.initState();
    place = widget.place;
    ReviewRepository _reviewRepository = ReviewRepository();
    _userReviewCubit =
        UserReviewCubit(repository: _reviewRepository, placeID: place.id);
  }

  @override
  void dispose() {
    _userReviewCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        extendBodyBehindAppBar: true,
        backgroundColor: MyColors.white,
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Carousel(place: place, heroAnimationTag: widget.heroAnimationTag),
            buildPlaceDetails(),
          ]),
        ));
  }

  Padding buildPlaceDetails() {
    return Padding(
      padding: EdgeInsets.all(18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleAndWishRow(title: place.title, wished: place.wished),
          const SizedBox(height: 20),
          LocationRow(place: place),
          const SizedBox(height: 16),
          const SizedBox(height: 16),
          Divider(
            thickness: 1.5,
          ),
          const SizedBox(height: 8),
          UserRow(place: place),
          const SizedBox(height: 8),
          DescriptionShowMoreText(text: place.description),
          const SizedBox(height: 8),
          TagsList(place: place),
          const SizedBox(height: 16),
          Divider(
            thickness: 1.5,
          ),
          const SizedBox(height: 8),
          Text(
            'Rating and Reviews',
            style: TextStyle(fontSize: 22, color: Colors.grey.withOpacity(0.8)),
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 16),
          UserReviewBlocBuilder(userReviewCubit: _userReviewCubit),
          const SizedBox(height: 62),
          ReviewsCountDisplay(place: place)
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }
}
