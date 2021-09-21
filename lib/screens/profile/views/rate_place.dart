import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:tahwisa/cubits/user_review_cubit/user_review_cubit.dart';
import 'package:tahwisa/screens/profile/widgets/add_place/title_text_field.dart';
import 'package:tahwisa/style/my_colors.dart';

class RatePlaceScreen extends StatefulWidget {
  static const String routeName = '/rate_place';

  static Route route({double initialRate, UserReviewCubit userReviewCubit}) {
    return MaterialPageRoute(
      builder: (_) => RatePlaceScreen(
          initialRate: initialRate, userReviewCubit: userReviewCubit),
      settings: RouteSettings(name: routeName),
    );
  }

  final double initialRate;
  final UserReviewCubit userReviewCubit;
  RatePlaceScreen({@required this.initialRate, @required this.userReviewCubit});

  @override
  _RatePlaceScreenState createState() => _RatePlaceScreenState();
}

class _RatePlaceScreenState extends State<RatePlaceScreen> {
  var initialRate;
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    initialRate = widget.initialRate;

    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Text(
            "Rate this place",
          ),
        ),
        body: BlocProvider.value(
          value: widget.userReviewCubit,
          child: BlocListener<UserReviewCubit, UserReviewState>(
              listener: (context, state) async {
                if (state is UserReviewPostSuccess) {
                  showDialog<void>(
                      context: context,
                      useRootNavigator: false,
                      barrierDismissible: true, // user must tap button!
                      builder: (BuildContext context) => AlertDialog(
                              content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Thanks for sharing"),
                              Text(
                                  "your feedback helps others make better decisions about which place to visit"),
                            ],
                          ))).then((value) => Navigator.of(context)
                      .popUntil(ModalRoute.withName('/place_details')));
                }
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 32,
                    ),
                    RatingBar(
                      onRatingChanged: (rating) {
                        setState(() {
                          initialRate = rating;
                        });
                      },
                      size: 48,
                      filledIcon: Icons.star,
                      emptyIcon: Icons.star_border,
                      halfFilledIcon: Icons.star_half,
                      emptyColor: MyColors.darkBlue,
                      filledColor: MyColors.darkBlue,
                      halfFilledColor: MyColors.darkBlue,
                      initialRating: initialRate,
                      maxRating: 5,
                      isHalfAllowed: true,
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 26),
                      child: TitleTextField(
                        titleEditingController: _textEditingController,
                        hint: "Describe your experience (optional)",
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Row(children: [
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 26, vertical: 8),
                            child:
                                BlocBuilder<UserReviewCubit, UserReviewState>(
                              builder: (context, state) => MaterialButton(
                                elevation: 7,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 26, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width * 0.1,
                                  ),
                                ),
                                onPressed: (state is UserReviewPostLoading)
                                    ? () {}
                                    : () {
                                        widget.userReviewCubit.postReview(
                                          rating: initialRate,
                                          comment:
                                              _textEditingController.value.text,
                                        );
                                      },
                                child: (state is UserReviewPostLoading)
                                    ? CircularProgressIndicator()
                                    : Text(
                                        "Post",
                                        style: TextStyle(
                                            color: MyColors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                            letterSpacing: 1.5),
                                      ),
                                color: MyColors.darkBlue,
                              ),
                            )),
                      ),
                    ])
                  ],
                ),
              )),
        ));
  }

  void _pop() {
    Navigator.of(context).pop();
  }
}
