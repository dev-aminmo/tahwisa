import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/blocs/notification_bloc/notification_bloc.dart';
import 'package:tahwisa/cubits/admin_cubit/admin_cubit.dart';
import 'package:tahwisa/cubits/place_availability_cubit/place_availability_cubit.dart';
import 'package:tahwisa/cubits/place_details_cubit/place_details_cubit.dart';
import 'package:tahwisa/cubits/refuse_place_messages/refuse_place_messages_cubit.dart';
import 'package:tahwisa/repositories/admin_repository.dart';
import 'package:tahwisa/repositories/models/notification.dart' as My;
import 'package:tahwisa/repositories/models/place.dart';
import 'package:tahwisa/repositories/models/refuse_place_message.dart';
import 'package:tahwisa/repositories/place_repository.dart';
import 'package:tahwisa/repositories/refuse_place_message_repository.dart';
import 'package:tahwisa/screens/profile/views/LocationDisplayScreen.dart';
import 'package:tahwisa/screens/profile/widgets/place_details/widgets.dart';
import 'package:tahwisa/screens/profile/widgets/static_map_view.dart';
import 'package:tahwisa/style/my_colors.dart';

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
  PlaceAvailabilityCubit _placeAvailabilityCubit;
  AdminCubit _adminCubit;
  RefusePlaceMessagesCubit _refusePlaceMessagesCubit;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    notification = widget.notification;
    widget.notificationBloc.add(ReadNotification(id: notification.id));
    var _adminRepository = context.read<AdminRepository>();
    _placeAvailabilityCubit = PlaceAvailabilityCubit(_adminRepository)
      ..checkIfPlaceIsAvailable(notification.placeId);

    _placeDetailsCubit = PlaceDetailsCubit(
        placeID: notification.placeId,
        placeRepository: context.read<PlaceRepository>());
    _adminCubit = AdminCubit(_adminRepository);
    _refusePlaceMessagesCubit =
        RefusePlaceMessagesCubit(context.read<RefusePlaceMessageRepository>());
    super.initState();
  }

  @override
  void dispose() {
    _placeDetailsCubit.close();
    _placeAvailabilityCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      extendBodyBehindAppBar: true,
      backgroundColor: MyColors.white,
      body: Center(
        child: BlocBuilder<PlaceAvailabilityCubit, PlaceAvailabilityState>(
          bloc: _placeAvailabilityCubit,
          builder: (context, state) {
            if (state is PlaceAvailabilityInitial) {
              return CircularProgressIndicator();
            }
            if (state is PlaceAvailable) {
              return MultiBlocListener(
                  listeners: [
                    BlocListener<RefusePlaceMessagesCubit,
                            RefusePlaceMessagesState>(
                        bloc: _refusePlaceMessagesCubit,
                        listener: (context, state) {
                          if (state is RefusePlaceMessagesLoading) {
                            showDialog<void>(
                                context: context,
                                useRootNavigator: false,
                                barrierDismissible: false,
                                builder: (BuildContext context) => WillPopScope(
                                    onWillPop: () async => false,
                                    child: AlertDialog(
                                        backgroundColor: Colors.white,
                                        content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator()
                                            ]))));
                          }
                          if (state is RefusePlaceMessagesError) {
                            Navigator.of(context).pop();
//Todo handle error
                          }
                          if (state is RefusePlaceMessagesSuccess) {
                            List<RefusePlaceMessage> _userChecked = [];
                            var _errorMessage = '';
                            String _description;
                            void _onSelected(
                                bool selected, RefusePlaceMessage message) {
                              if (selected == true) {
                                setState(() {
                                  _userChecked.add(message);
                                });
                              } else {
                                setState(() {
                                  _userChecked.remove(message);
                                });
                              }
                            }

                            Navigator.of(context).pop();
                            showDialog<void>(
                                context: context,
                                useRootNavigator: false,
                                barrierDismissible: true,
                                builder: (context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) =>
                                          AlertDialog(
                                            backgroundColor: Colors.white,
                                            content: Form(
                                                key: _formKey,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    ...state.refusePlaceMessages
                                                        .map((message) =>
                                                            ListTile(
                                                              title: Text(
                                                                  message.name),
                                                              trailing:
                                                                  Checkbox(
                                                                value: _userChecked
                                                                    .contains(
                                                                        message),
                                                                onChanged:
                                                                    (val) {
                                                                  setState(() {
                                                                    _onSelected(
                                                                        val,
                                                                        message);
                                                                  });
                                                                },
                                                              ),
                                                            ))
                                                        .toList(),
                                                    Text(_errorMessage,
                                                        style: TextStyle(
                                                            color: Colors.red)),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: TextFormField(
                                                        decoration: InputDecoration(
                                                            hintText:
                                                                "Description (Optional)"),
                                                        onChanged: (value) =>
                                                            _description =
                                                                value,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {});
                                                  if (_userChecked.length > 0) {
                                                    _errorMessage = '';
                                                    print(notification.placeId);
                                                    print(notification.id);
                                                    Navigator.pop(context);

                                                    _adminCubit.refusePlace(
                                                        placeId: notification
                                                            .placeId,
                                                        messages: _userChecked,
                                                        description:
                                                            _description);
                                                  } else {
                                                    _errorMessage =
                                                        "check at least one message";
                                                  }
                                                },
                                                child: Text('Send'),
                                              ),
                                            ],
                                          ));
                                });
                          }
                        }),
                    BlocListener<AdminCubit, AdminState>(
                        bloc: _adminCubit,
                        listener: (context, state) {
                          if (state is AdminLoading) {
                            showDialog<void>(
                                context: context,
                                useRootNavigator: false,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) => WillPopScope(
                                    onWillPop: () async => false,
                                    child: AlertDialog(
                                        backgroundColor: Colors.white,
                                        content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator()
                                            ]))));
                          }
                          if (state is AdminSuccess) {
                            Navigator.of(context).pop();
                            showDialog<void>(
                                context: context,
                                useRootNavigator: false,
                                barrierDismissible:
                                    true, // user must tap button!
                                builder: (BuildContext context) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.check_circle_outlined,
                                          color: Colors.green,
                                          size: 72,
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          "Your request has been successfully submitted",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 22,
                                              color: MyColors.darkBlue),
                                        ),
                                        const SizedBox(height: 16),
                                      ],
                                    ))).then((value) {
                              Navigator.of(context, rootNavigator: true).pop();
                            });
                          }
                          if (state is AdminError) {
                            Navigator.of(context).pop();
                            showDialog<void>(
                                context: context,
                                useRootNavigator: false,
                                barrierDismissible:
                                    true, // user must tap button!
                                builder: (BuildContext context) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.error_outline_rounded,
                                          color: Colors.red,
                                          size: 72,
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          "This post has been handled by another Admin",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.2,
                                            fontSize: 18,
                                            color: Colors.red,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                      ],
                                    ))).then((value) {
                              Navigator.of(context, rootNavigator: true).pop();
                            });
                          }
                        }),
                  ],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child:
                            BlocBuilder<PlaceDetailsCubit, PlaceDetailsState>(
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
                      Column(
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 16,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  _refusePlaceMessagesCubit
                                      .getAdminRefusePlaceMessages();
                                },
                                child: Text(
                                  "Refuse",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                color: Colors.redAccent,
                              ),
                              Spacer(),
                              MaterialButton(
                                onPressed: () {
                                  if (_adminCubit.state is! AdminLoading) {
                                    _adminCubit
                                        .approvePlace(notification.placeId);
                                  }
                                },
                                child: Text(
                                  "Approve",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: 16,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ],
                  ));
            }
            if (state is PlaceUnAvailable) {
              return Text("This Notification is No Longer available");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Padding buildPlaceDetails(Place place) {
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
