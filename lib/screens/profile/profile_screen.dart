import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/blocs/authentication_bloc/bloc.dart';
import 'package:tahwisa/blocs/notification_bloc/notification_bloc.dart';
import 'package:tahwisa/cubits/fcm_token_cubit/fcm_token_cubit.dart';
import 'package:tahwisa/cubits/user_cubit/user_cubit.dart';
import 'package:tahwisa/repositories/fcm_token_repository.dart';
import 'package:tahwisa/repositories/models/notification.dart' as My;
import 'package:tahwisa/repositories/notification_repository.dart';
import 'package:tahwisa/repositories/place_repository.dart';
import 'package:tahwisa/repositories/user_repository.dart';
import 'package:tahwisa/style/my_colors.dart';

import 'views/explore.dart';
import 'views/notifications.dart';
import 'views/search.dart';
import 'views/wish_list.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with WidgetsBindingObserver {
  AuthenticationBloc authenticationBloc;
  PlaceRepository placeRepository;
  PageController _pageController;
  int _currentIndex;
  List<Widget> children;
  UserRepository userRepository;
  UserCubit _userCubit;
  FcmCubit fcmCubit;
  NotificationBloc notificationBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MyColors.white,
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: children,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _buildFloatingActionButton(),
        bottomNavigationBar: _bottomAppBar(),
        drawer: _buildDrawer());
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: BlocBuilder<UserCubit, UserState>(
          bloc: _userCubit,
          builder: (context, state) {
            if (state is UserSuccess) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(state.user.name),
                    accountEmail: Text(state.user.email),
                    decoration: BoxDecoration(color: MyColors.darkBlue),
                    currentAccountPicture: CircleAvatar(
                      radius: 152,
                      backgroundImage: NetworkImage(
                        state.user.profilePicture.replaceFirstMapped(
                            "image/upload/",
                            (match) => "image/upload/w_150,f_auto/"),
                      ),
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  LayoutBuilder(
                    builder: (ctx, constraints) {
                      return GestureDetector(
                        onTap: () {
                          authenticationBloc.add(LoggedOut());
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          margin: EdgeInsets.symmetric(
                              horizontal: 48, vertical: 12),
                          decoration: BoxDecoration(
                              color: MyColors.lightGreen,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          child: Row(
                            children: [
                              Spacer(),
                              Text("Logout",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 22)),
                              Spacer(),
                              Icon(Icons.logout, color: Colors.white),
                              Spacer(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    var notification = My.Notification(
      id: message.data['id'],
      title: message.notification?.title,
      body: message.notification?.body,
      description: message.data['description'],
      placeId: message.data['place_id'],
      type: message.data['type'],
    );
    if (notification.type == 'place_added') {
      notificationBloc.add(ReadNotification(id: notification.id));

      Navigator.of(context).pushNamed(
        '/notification/place_added',
        arguments: {
          'notificationBloc': notificationBloc,
          'notification': notification
        },
      );
    }
    if (notification.type == 'place_refused') {
      notificationBloc.add(ReadNotification(id: notification.id));

      Navigator.of(context).pushNamed(
        '/notification/place_refused',
        arguments: {'notification': notification},
      );
    }
    if (notification.type == 'place_approved') {
      notificationBloc.add(ReadNotification(id: notification.id));

      Navigator.of(context).pushNamed(
        '/place_details',
        arguments: {
          'heroAnimationTag': "notification",
          'placeId': notification.placeId,
        },
      );
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    setupInteractedMessage();
    _currentIndex = 0;
    _pageController = PageController(initialPage: _currentIndex);

    notificationBloc = NotificationBloc(
        notificationRepository: context.read<NotificationRepository>());
    children = [
      Explore(),
      SearchScreen(),
      Container(),
      WishList(),
      BlocProvider<NotificationBloc>.value(
        value: notificationBloc,
        child: Notifications(),
      )
    ];
    placeRepository = RepositoryProvider.of<PlaceRepository>(context);
    userRepository = RepositoryProvider.of<UserRepository>(context);
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _userCubit = UserCubit(userRepository: userRepository);
    var fcmTokenRepository = RepositoryProvider.of<FcmTokenRepository>(context);
    fcmCubit = FcmCubit(repository: fcmTokenRepository);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _userCubit.close();
    fcmCubit.close();
    notificationBloc.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("hey resumed **********");
      notificationBloc.add(FetchNotifications(loading: false));
    }
  }

  void _selectItem(int value) {
    setState(() {
      _currentIndex = value;
      _pageController.jumpToPage(_currentIndex);
    });
  }

  _bottomAppBar() => BottomAppBar(
        color: Colors.white,
        notchMargin: 6,
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(width: 2, color: MyColors.darkBlue)),
          ),
          child: _bottomNavigationBar(),
        ),
      );
  BottomNavigationBar _bottomNavigationBar() => BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        unselectedItemColor: Color(0xffcacaca),
        fixedColor: MyColors.lightGreen,
        type: BottomNavigationBarType.fixed,
        backgroundColor: MyColors.white,
        iconSize: 32,
        onTap: _selectItem,
        items: _bottomNavigationBarItems(),
      );
  List<BottomNavigationBarItem> _bottomNavigationBarItems() => [
        BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.bookmark,
            size: 0,
            color: Colors.transparent,
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border_outlined),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: StreamBuilder<int>(
              stream: notificationBloc.unreadNotifications,
              builder: (context, snapshot) {
                return (snapshot.hasData && snapshot.data != 0)
                    ? Stack(
                        children: [
                          Icon(Icons.notifications_none_outlined),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              decoration: new BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Center(
                                child: Text(
                                  '${snapshot.data}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    : Icon(Icons.notifications_none_outlined);
              }),
          label: "",
        ),
      ];

  _buildFloatingActionButton() => SizedBox(
        width: 58,
        height: 58,
        child: FloatingActionButton(
          backgroundColor: MyColors.darkBlue,
          onPressed: () {
            Navigator.of(context).pushNamed('/add_place_navigator');
          },
          child: Icon(Icons.add,
              size: 28, color: Theme.of(context).scaffoldBackgroundColor),
        ),
      );
}
