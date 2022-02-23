import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/cubits/place_details_cubit/place_details_cubit.dart';
import 'package:tahwisa/repositories/models/place.dart';
import 'package:tahwisa/screens/profile/views/LocationDisplayScreen.dart';
import 'package:tahwisa/screens/profile/widgets/place_details/widgets.dart';

import '../../static_map_view.dart';

class NotificationPlaceDetails extends StatelessWidget {
  final _placeDetailsCubit;

  NotificationPlaceDetails(this._placeDetailsCubit);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<PlaceDetailsCubit, PlaceDetailsState>(
        bloc: _placeDetailsCubit,
        builder: (context, state) {
          if (state is PlaceDetailsSuccess) {
            return SingleChildScrollView(
                padding: EdgeInsets.zero,
                physics: const ClampingScrollPhysics(),
                child: Column(children: [
                  Carousel(
                      place: state.place, heroAnimationTag: "notification"),
                  buildPlaceDetails(state.place!, context),
                ] //]),
                    ));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Padding buildPlaceDetails(Place place, context) {
    return Padding(
      padding: EdgeInsets.all(18),
      child: Column(
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
            style: TextStyle(fontSize: 12, color: Colors.grey.withOpacity(0.8)),
          ),
          const SizedBox(height: 8),
          UserRow(place: place),
          const SizedBox(height: 16),
          DescriptionShowMoreText(text: place.description),
          const SizedBox(height: 8),
          TagsList(place: place),
        ],
      ),
    );
  }
}
