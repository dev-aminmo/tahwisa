import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/repositories/user_repository.dart';

import 'package:tahwisa/blocs/authentication_bloc/bloc.dart';
import 'package:tahwisa/screens/auth/login.dart';
import 'package:tahwisa/screens/welcome.dart';
import 'package:tahwisa/style/my_colors.dart';
import 'repositories/place_repository.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/views/add_place.dart';
import 'screens/auth/signup.dart';

import 'package:tahwisa/screens/auth/login.dart';

class SimpleBlocDelegate extends BlocObserver {
  @override
  void onChange(Cubit cubit, Change change) {
    print(change.toString());

    super.onChange(cubit, change);
  }
}

void main() {
  Bloc.observer = SimpleBlocDelegate();
  runApp(App(/*userRepository: UserRepository()*/));
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AuthenticationBloc authenticationBloc;
  UserRepository userRepository;


  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  void initState() {
    userRepository=UserRepository();
    authenticationBloc = AuthenticationBloc(userRepository: userRepository);
    authenticationBloc.add(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    authenticationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
        create: (context) => authenticationBloc,
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          title: 'Tahwisa',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            //primarySwatch: Colors.blue,
            primaryColor: MyColors.darkBlue,
            indicatorColor: MyColors.lightGreen,
            accentColor: MyColors.lightGreen,
            scaffoldBackgroundColor: MyColors.white,

            fontFamily: 'Lato',
            backgroundColor: MyColors.white,
          ),
          builder: (context, child) {
            return RepositoryProvider(
              create: (_)=>userRepository,
              child: BlocListener<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  if (state is AuthenticationAuthenticated) {
                    _navigator.pushAndRemoveUntil<void>(
                      //HomePage.route(),
                      MaterialPageRoute<void>(
                          builder: (context) => RepositoryProvider(
                            create:(_)=> PlaceRepository(),
                              child: ProfileScreen())),
                      (route) => false,
                    );
                  } else if (state is AuthenticationUnauthenticated) {
                    _navigator.pushAndRemoveUntil<void>(
                      //  LoginPage.route(),
                      MaterialPageRoute<void>(
                          builder: (context) =>
                              WelcomeScreen()),
                      (route) => false,
                    );
                  }
                },
                child: child,
              ),
            );
          },
          onGenerateRoute: _getRoute,
        ));
  }

  Route _getRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => SplashPage());
        break;
      case '/home':
        return MaterialPageRoute(
            builder: (context) =>
                WelcomeScreen());
        break;
      case '/login':
        //final page = LoginPage(settings.arguments);
        return MaterialPageRoute(builder: (context) => LoginPage());
        break;
      case '/sign_up':
        final page = SignUPScreen(settings.arguments);
        return MaterialPageRoute(builder: (context) => page);

      case '/add_place':
        return MaterialPageRoute(builder: (context) => AddPlace());
    }
  }
}
