import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:readmore/readmore.dart';
import 'package:tahwisa/repositories/models/place.dart';
import 'package:tahwisa/screens/profile/widgets/rating_bar_stars_read_only.dart';
import 'package:tahwisa/style/my_colors.dart';

class PlaceDetailsScreen extends StatefulWidget {
  static const String routeName = '/place_details';

  static Route route({@required Place place}) {
    return MaterialPageRoute(
      builder: (_) => PlaceDetailsScreen(place: place),
      settings: RouteSettings(name: routeName),
    );
  }

  final Place place;

  const PlaceDetailsScreen({
    @required this.place,
  });

  @override
  _PlaceDetailsScreenState createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  var currentPosition = 0;
  Place place;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: buildAppBar(),
        extendBodyBehindAppBar: true,
        backgroundColor: MyColors.white,
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            buildCarouselSlider(width),
            buildCarouselDots(),
            Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTitleAndWishRow(),
                  const SizedBox(height: 20),
                  buildLocationRow(),
                  const SizedBox(height: 16),
                  buildRatingBarReadOnlyRow(),
                  const SizedBox(height: 16),
                  Divider(
                    thickness: 1.5,
                  ),
                  const SizedBox(height: 8),
                  buildUserRow(),
                  const SizedBox(height: 8),
                  ShowMoreText(text: place.description),
                  const SizedBox(height: 8),
                  _buildTagsList()
                ],
              ),
            ),
          ]),
        ));
  }

  Row buildUserRow() {
    return Row(children: [
      CircleAvatar(
        minRadius: 28,
        backgroundColor: MyColors.gray,
        backgroundImage: NetworkImage(
          place.user.profilePicture.replaceFirstMapped(
              "image/upload/", (match) => "image/upload/w_150,f_auto/"),
        ),
      ),
      const SizedBox(width: 16),
      Flexible(
        child: Text(
          place.user.name,
          textAlign: TextAlign.left,
          softWrap: true,
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: MyColors.darkBlue),
        ),
      ),
    ]);
  }

  GestureDetector buildLocationRow() {
    return GestureDetector(
      onTap: () {
        print("hello fron wilaya");
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.translate(
            offset: Offset(-3, -4),
            child: Icon(
              Icons.location_on,
              size: 22,
              color: Color(0xff54D3C2),
            ),
          ),
          Flexible(
            child: Text('${place.state}, ${place.municipal}',
                softWrap: true,
                style: TextStyle(
                  shadows: [
                    Shadow(color: MyColors.darkBlue, offset: Offset(0, -5))
                  ],
                  color: Colors.transparent,
                  decoration: TextDecoration.underline,
                  decorationColor: MyColors.darkBlue,
                  fontSize: 18,
                )
                //color: MyColors.darkBlue),
                ),
          ),
        ],
      ),
    );
  }

  _buildTagsList() {
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: place.tags.map((tag) => TagChip(tag.name)).toList(),
    );
  }

  Row buildRatingBarReadOnlyRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RatingBarStarsReadOnly(
          reviewsAverage: place.reviewsAverage,
          iconSize: 36.0,
        ),
        Transform.translate(
          offset: Offset(0, 5),
          child: Text(
            ' ( ${place.reviewsCount} Reviews ).',
            style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8)),
          ),
        ),
      ],
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

  Row buildTitleAndWishRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            place.title,
            textAlign: TextAlign.left,
            softWrap: true,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: MyColors.darkBlue),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(
              Radius.circular(32.0),
            ),
            onTap: () {},
            child: Icon(
              //Icons.favorite_outlined,
              (place.wished) ? Icons.favorite_outlined : Icons.favorite_border,
              color: MyColors.lightGreen,
              size: 32,
            ),
          ),
        ),
      ],
    );
  }

  Row buildCarouselDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: place.pictures.map((picture) {
        int index = place.pictures.indexOf(picture);
        return Container(
          width: 12.0,
          height: 12.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPosition == index
                ? MyColors.darkBlue
                : MyColors.darkBlue.withOpacity(0.4),
          ),
        );
      }).toList(),
    );
  }

  Widget buildCarouselSlider(double width) {
    return Container(
      color: Colors.black,
      child: CarouselSlider.builder(
          options: CarouselOptions(
              scrollPhysics: const BouncingScrollPhysics(),
              disableCenter: false,
              enableInfiniteScroll: false,
              aspectRatio: 1.1,
              onPageChanged: (index, reason) {
                setState(() {
                  currentPosition = index;
                });
              },
              viewportFraction: 1),
          itemCount: place.pictures.length,
          itemBuilder: (context, index, realIndex) {
            return GestureDetector(
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FullScreenPage(
                                  child: PhotoView(
                                imageProvider:
                                    NetworkImage(place.pictures[index]),
                              ))),
                    ),
                child: SizedBox(
                  width: double.infinity,
                  child: Hero(
                    tag: 'place_tag${place.id}',
                    child: Image.network(
                      place.pictures[index].replaceFirstMapped(
                          "image/upload/",
                          (match) =>
                              "image/upload/w_${(width).round()},f_auto/"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ));
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    place = widget.place;
  }
}

class TagChip extends StatelessWidget {
  const TagChip(
    this.label,
  );
  final label;
  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: EdgeInsets.all(2.0),
      label: Text(
        "#" + label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: MyColors.greenBorder,
      elevation: 3.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    );
  }
}

class ShowMoreText extends StatefulWidget {
  const ShowMoreText({
    Key key,
    @required this.text,
  }) : super(key: key);

  final text;

  @override
  _ShowMoreTextState createState() => _ShowMoreTextState();
}

class _ShowMoreTextState extends State<ShowMoreText> {
  bool _readMore = true;
  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      widget.text,
      callback: (bool) {
        print(bool);
        setState(() {
          _readMore = bool;
        });
      },
      delimiter: _readMore ? '...' : '',
      trimLines: 2,
      colorClickableText: MyColors.lightGreen,
      trimMode: TrimMode.Line,
      style: TextStyle(color: MyColors.gray),
      trimCollapsedText: ' Show more',
      trimExpandedText: ' Show less',
      lessStyle: TextStyle(
          fontSize: 16,
          color: MyColors.lightGreen,
          fontWeight: FontWeight.bold),
      moreStyle: TextStyle(
          fontSize: 16,
          color: MyColors.lightGreen,
          fontWeight: FontWeight.bold),
    );
  }
}

class FullScreenPage extends StatefulWidget {
  FullScreenPage({
    @required this.child,
  });

  final Widget child;

  @override
  _FullScreenPageState createState() => _FullScreenPageState();
}

class _FullScreenPageState extends State<FullScreenPage> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: widget.child,
    );
  }
}
