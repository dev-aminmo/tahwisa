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
import 'package:tahwisa/repositories/models/refuse_place_message.dart';
import 'package:tahwisa/repositories/place_repository.dart';
import 'package:tahwisa/repositories/refuse_place_message_repository.dart';
import 'package:tahwisa/screens/profile/widgets/404.dart';
import 'package:tahwisa/screens/profile/widgets/notification/added/approve_refuse_buttons.dart';
import 'package:tahwisa/screens/profile/widgets/notification/added/notification_place_details.dart';
import 'package:tahwisa/style/my_colors.dart';

import 'file:///C:/Users/pc/AndroidStudioProjects/tahwisa/lib/screens/profile/widgets/notification/added/error_alert.dart';
import 'file:///C:/Users/pc/AndroidStudioProjects/tahwisa/lib/screens/profile/widgets/notification/added/loading_alert.dart';
import 'file:///C:/Users/pc/AndroidStudioProjects/tahwisa/lib/screens/profile/widgets/notification/added/success_alert.dart';

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
    super.initState();
    notification = widget.notification;
    var _adminRepository = context.read<AdminRepository>();
    _placeAvailabilityCubit = PlaceAvailabilityCubit(_adminRepository)
      ..checkIfPlaceIsAvailable(notification.placeId);
    _placeDetailsCubit = PlaceDetailsCubit(
        placeID: notification.placeId,
        placeRepository: context.read<PlaceRepository>());
    _adminCubit = AdminCubit(_adminRepository);
    _refusePlaceMessagesCubit =
        RefusePlaceMessagesCubit(context.read<RefusePlaceMessageRepository>());
  }

  @override
  void dispose() {
    _placeDetailsCubit.close();
    _placeAvailabilityCubit.close();
    _adminCubit.close();
    _refusePlaceMessagesCubit.close();
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
                                builder: (BuildContext context) =>
                                    StatefulBuilder(
                                        builder: (BuildContext context,
                                                StateSetter setState) =>
                                            LoadingAlert()));
                          }

                          if (state is RefusePlaceMessagesError) {
                            Navigator.of(context).pop();
                            showDialog<void>(
                                context: context,
                                useRootNavigator: false,
                                barrierDismissible:
                                    true, // user must tap button!
                                builder: (BuildContext context) => StatefulBuilder(
                                    builder: (context, setState) => ErrorAlert(
                                        message:
                                            "Cannot make an action now please retry later"))).then(
                                (value) {
                              Navigator.of(context, rootNavigator: true).pop();
                            });
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
                                barrierDismissible: false,
                                builder: (BuildContext context) =>
                                    StatefulBuilder(
                                        builder: (BuildContext context,
                                                StateSetter setState) =>
                                            LoadingAlert()));
                          }
                          if (state is AdminSuccess) {
                            Navigator.of(context).pop();
                            showDialog<void>(
                                context: context,
                                useRootNavigator: false,
                                barrierDismissible:
                                    true, // user must tap button!
                                builder: (BuildContext context) =>
                                    StatefulBuilder(
                                      builder: (context, setState) =>
                                          SuccessAlert(),
                                    )).then((value) {
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
                                builder: (BuildContext context) =>
                                    StatefulBuilder(
                                        builder: (context, setState) =>
                                            ErrorAlert())).then((value) {
                              Navigator.of(context, rootNavigator: true).pop();
                            });
                          }
                        }),
                  ],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      NotificationPlaceDetails(_placeDetailsCubit),
                      ApproveRefuseButtons(
                          _refusePlaceMessagesCubit, _adminCubit, notification)
                    ],
                  ));
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
