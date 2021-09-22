import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/cubits/reviews_cubit/reviews_cubit.dart';
import 'package:tahwisa/screens/profile/widgets/place_details/review_item.dart';

class ReviewsScreen extends StatefulWidget {
  static const String routeName = '/reviews';

  static Route route({ReviewsCubit reviewsCubit}) {
    return MaterialPageRoute(
      builder: (_) => ReviewsScreen(
        reviewsCubit: reviewsCubit,
      ),
      settings: RouteSettings(name: routeName),
    );
  }

  final ReviewsCubit reviewsCubit;
  ReviewsScreen({
    @required this.reviewsCubit,
  });

  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  @override
  void dispose() {
    widget.reviewsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Text(
            "Reviews",
          ),
        ),
        body: BlocProvider.value(
          value: widget.reviewsCubit,
          child: BlocConsumer<ReviewsCubit, ReviewsState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is ReviewsSuccess) {
                  return ListView.separated(
                      separatorBuilder: (_, __) {
                        return Divider(
                          indent: 32,
                          endIndent: 32,
                          height: 16,
                        );
                      },
                      padding: EdgeInsets.all(
                        16,
                      ),
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: state.reviews.length,
                      itemBuilder: (context, index) =>
                          ReviewItem(state.reviews[index]));
                } else
                  return SizedBox();
              }),
        ));
  }
}
