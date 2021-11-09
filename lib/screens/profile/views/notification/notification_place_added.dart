import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/blocs/notification_bloc/notification_bloc.dart';
import 'package:tahwisa/cubits/place_details_cubit/place_details_cubit.dart';
import 'package:tahwisa/repositories/models/notification.dart' as My;
import 'package:tahwisa/repositories/models/place.dart';
import 'package:tahwisa/repositories/place_repository.dart';
import 'package:tahwisa/screens/profile/views/LocationDisplayScreen.dart';
import 'package:tahwisa/screens/profile/widgets/place_details/widgets.dart';
import 'package:tahwisa/screens/profile/widgets/static_map_view.dart';

class NotificationPlaceAdded extends StatefulWidget {
  static const String routeName = '/notification/place_added';

  static Route route(
      {@required NotificationBloc notificationBloc,
      My.Notification notification}) {
    return MaterialPageRoute(
      builder: (_) => NotificationPlaceAdded(
        notificationBloc: notificationBloc,
        notification: notification,
      ),
      settings: RouteSettings(name: routeName),
    );
  }

  final NotificationBloc notificationBloc;
  final My.Notification notification;

  const NotificationPlaceAdded({this.notificationBloc, this.notification});
  @override
  _NotificationPlaceAddedState createState() => _NotificationPlaceAddedState();
}

class _NotificationPlaceAddedState extends State<NotificationPlaceAdded> {
  PlaceDetailsCubit _placeDetailsCubit;
  My.Notification notification;

  @override
  void initState() {
    notification = widget.notification;
    widget.notificationBloc.add(ReadNotification(id: notification.id));
    _placeDetailsCubit = PlaceDetailsCubit(
        placeID: notification.placeId,
        placeRepository: context.read<PlaceRepository>());
    super.initState();
  }

  @override
  void dispose() {
    _placeDetailsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<PlaceDetailsCubit, PlaceDetailsState>(
                bloc: _placeDetailsCubit,
                builder: (context, state) {
                  if (state is PlaceDetailsSuccess) {
                    return SingleChildScrollView(
                        padding: EdgeInsets.zero,
                        physics: ClampingScrollPhysics(),
                        child: Column(children: [
                          Carousel(
                              place: state.place,
                              heroAnimationTag: "notification"),
                          buildPlaceDetails(state.place),
                        ] //]),
                            ));
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            const Divider(
              height: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 50, height: 200),
                Text("Accept    "),
                Text("  Refuse"),
              ],
            ),
          ],
        ),
      ),
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

          //    ReviewBlocBuilder(reviewCubit: _userReviewCubit),
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
