import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/blocs/authentication_bloc/bloc.dart';
import 'views/notifications.dart';
import 'views/wish_list.dart';
import 'package:tahwisa/style/my_colors.dart';

import 'views/explore.dart';
import 'views/search.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthenticationBloc authenticationBloc;
  int _currentIndex = 0;
  List<Widget> children = [
    Explore(),
    SearchScreen(),
    Container(),
    WishList(),
    Notifications(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      body: children[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 58,
        height: 58,
        child: FloatingActionButton(
          backgroundColor: MyColors.darkBlue,
          onPressed: () {
            Navigator.of(context).pushNamed('/add_place');
          },
          child: Icon(Icons.add,
              size: 28, color: Theme.of(context).scaffoldBackgroundColor),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        //   shape: CircularNotchedRectangle(),
        notchMargin: 6,
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(width: 2, color: MyColors.darkBlue)),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            unselectedItemColor: Color(0xffcacaca),
            fixedColor: MyColors.lightGreen,
            type: BottomNavigationBarType.fixed,
            backgroundColor: MyColors.white,
            iconSize: 32,
            onTap: _selectItem,
            items: [
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
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Mohammed'),
              accountEmail: Text("mostefaoui@gmail.com"),
              decoration: BoxDecoration(color: MyColors.darkBlue),
              currentAccountPicture: CircleAvatar(
                radius: 152,
                backgroundImage: NetworkImage(
                  "https://source.unsplash.com/random/100x100?profil",
                ),
                backgroundColor: Colors.grey,
              ),
            ),
            LayoutBuilder(
              builder: (ctx, constraints) {
                print(constraints.maxWidth);
                return GestureDetector(
                  onTap: () {
                    authenticationBloc.add(LoggedOut());
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    margin: EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                    decoration: BoxDecoration(
                        color: MyColors.lightGreen,
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Row(
                      children: [
                        Spacer(),
                        Text("Logout",
                            style:
                                TextStyle(color: Colors.white, fontSize: 22)),
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
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  @override
  void dispose() {
    authenticationBloc.close();
    super.dispose();
  }

  Widget _selectItem(int value) {
    setState(() {
      _currentIndex = value;
    });
  }
}
