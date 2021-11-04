import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/blocs/authentication_bloc/bloc.dart';
import 'package:tahwisa/blocs/notification_bloc/notification_bloc.dart';
import 'package:tahwisa/cubits/fcm_token_cubit/fcm_token_cubit.dart';
import 'package:tahwisa/cubits/user_cubit/user_cubit.dart';
import 'package:tahwisa/repositories/fcm_token_repository.dart';
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

class _ProfileScreenState extends State<ProfileScreen> {
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

// It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      print("initialMessage");
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print("Remote message has come ************************");
    Navigator.of(context).pushNamed('/add_place_navigator');
  }

  @override
  void initState() {
    super.initState();
    setupInteractedMessage();

    _currentIndex = 0;
    _pageController = PageController(initialPage: _currentIndex);
    children = [
      Explore(),
      SearchScreen(),
      Container(),
      WishList(),
      Notifications(),
    ];
    placeRepository = RepositoryProvider.of<PlaceRepository>(context);
    userRepository = RepositoryProvider.of<UserRepository>(context);
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _userCubit = UserCubit(userRepository: userRepository);
    var fcmTokenRepository = RepositoryProvider.of<FcmTokenRepository>(context);
    fcmCubit = FcmCubit(repository: fcmTokenRepository);
    var notificationRepository =
        RepositoryProvider.of<NotificationRepository>(context);
    notificationBloc =
        NotificationBloc(notificationRepository: notificationRepository);
  }

  @override
  void dispose() {
    _userCubit.close();
    fcmCubit.close();
    notificationBloc.close();
    super.dispose();
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
          icon: Icon(Icons.notifications_none_outlined),
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
