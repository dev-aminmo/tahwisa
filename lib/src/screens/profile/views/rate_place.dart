import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/src/cubits/user_review_cubit/user_review_cubit.dart';
import 'package:tahwisa/src/screens/profile/widgets/add_place/title_text_field.dart';
import 'package:tahwisa/src/style/my_colors.dart';

class RatePlaceScreen extends StatefulWidget {
  static const String routeName = '/rate_place';

  static Route route(
      {double? initialRate,
      required UserReviewCubit userReviewCubit,
      String? initialComment}) {
    return MaterialPageRoute(
      builder: (_) => RatePlaceScreen(
          initialRate: initialRate,
          userReviewCubit: userReviewCubit,
          initialComment: initialComment),
      settings: RouteSettings(name: routeName),
    );
  }

  final double? initialRate;
  late final UserReviewCubit userReviewCubit;
  final String? initialComment;
  RatePlaceScreen(
      {required this.initialRate,
      required this.userReviewCubit,
      this.initialComment});

  @override
  _RatePlaceScreenState createState() => _RatePlaceScreenState();
}

class _RatePlaceScreenState extends State<RatePlaceScreen> {
  var initialRate;
  TextEditingController? _textEditingController;

  @override
  void initState() {
    super.initState();
    initialRate = widget.initialRate;
    _textEditingController = TextEditingController(text: widget.initialComment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
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
                          backgroundColor: Colors.white,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star_outlined,
                                color: MyColors.darkBlue,
                                size: 72,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Thanks for sharing",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 22,
                                    color: MyColors.darkBlue),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "your feedback helps others make better decisions about which place to visit",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: MyColors.gray),
                              )
                            ],
                          ))).then((value) {
                    Navigator.of(context)
                        .popUntil(ModalRoute.withName('/place_details'));
                  });
                }
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 32,
                    ),
                    Hero(
                      tag: "rate",
                      child: /* RatingBar(
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
                      )*/
                          Container(),
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
                                          comment: _textEditingController!
                                              .value.text,
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
}
