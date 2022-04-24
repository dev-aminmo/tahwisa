import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/src/cubits/place_availability_cubit/place_availability_cubit.dart';
import 'package:tahwisa/src/cubits/refuse_place_messages/refuse_place_messages_cubit.dart';
import 'package:tahwisa/src/repositories/admin_repository.dart';
import 'package:tahwisa/src/repositories/models/notification.dart' as My;
import 'package:tahwisa/src/repositories/refuse_place_message_repository.dart';
import 'package:tahwisa/src/screens/profile/widgets/404.dart';
import 'package:tahwisa/src/style/my_colors.dart';

class NotificationPlaceRefused extends StatefulWidget {
  static const String routeName = '/notification/place_refused';

  static Route route({My.Notification? notification}) {
    return MaterialPageRoute(
      builder: (_) => NotificationPlaceRefused(
        notification: notification,
      ),
      settings: RouteSettings(name: routeName),
    );
  }

  final My.Notification? notification;

  const NotificationPlaceRefused({this.notification});

  @override
  _NotificationPlaceRefusedState createState() =>
      _NotificationPlaceRefusedState();
}

class _NotificationPlaceRefusedState extends State<NotificationPlaceRefused> {
  RefusePlaceMessagesCubit? _refusePlaceMessagesCubit;
  PlaceAvailabilityCubit? _placeAvailabilityCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<PlaceAvailabilityCubit, PlaceAvailabilityState>(
          bloc: _placeAvailabilityCubit,
          builder: (context, state) {
            if (state is PlaceAvailabilityInitial) {
              return CircularProgressIndicator();
            }
            if (state is PlaceAvailable) {
              return BlocBuilder<RefusePlaceMessagesCubit,
                  RefusePlaceMessagesState>(
                bloc: _refusePlaceMessagesCubit,
                builder: (context, state) {
                  if (state is RefusePlaceMessagesLoading) {
                    return CircularProgressIndicator();
                  }
                  if (state is RefusePlaceMessagesSuccess) {
                    return SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 36,
                              ),
                              Text(
                                "Your post has been refused for these reasons:",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: MyColors.darkBlue),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              ...state.refusePlaceMessages
                                  .map((e) => Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("• "),
                                          Expanded(
                                            child: Text(e.name),
                                          ),
                                        ],
                                      ))
                                  .toList(),
                              SizedBox(
                                height: 16,
                              ),
                              if ((widget.notification!.description?.length ??
                                      0) >
                                  0)
                                Row(
                                  children: [
                                    Text(
                                      "Description: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: MyColors.darkBlue),
                                    ),
                                    Text(widget.notification!.description)
                                  ],
                                ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                margin: EdgeInsets.symmetric(vertical: 24),
                                color: Colors.grey.shade200,
                                child: Text(
                                    'You can update your post to be re-reviewed',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: MyColors.darkBlue)),
                              ),
                              Divider(),
                              SizedBox(
                                height: 36,
                              ),
                              MaterialButton(
                                minWidth: double.infinity,
                                color: MyColors.darkBlue,
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                    '/place/update',
                                    arguments: {
                                      'placeId': widget.notification!.placeId
                                    },
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    "Update Place",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 36,
                              ),
                            ]),
                      ),
                    );
                  }
                  if (state is RefusePlaceMessagesError) {
                    return Text("Error");
                  }
                  return Text("");
                },
              );
            }
            if (state is PlaceUnAvailable) {
              return Page404();
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _placeAvailabilityCubit =
        PlaceAvailabilityCubit(context.read<AdminRepository>())
          ..checkIfPlaceIsAvailable(widget.notification!.placeId, update: true);
    _refusePlaceMessagesCubit =
        RefusePlaceMessagesCubit(context.read<RefusePlaceMessageRepository>());
    _refusePlaceMessagesCubit!.getRefusePlaceMessages(widget.notification!.id);
  }

  @override
  void dispose() {
    _placeAvailabilityCubit!.close();
    _refusePlaceMessagesCubit!.close();

    super.dispose();
  }
}
