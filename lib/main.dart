import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/repositories/user_repository.dart';

import 'package:tahwisa/blocs/authentication_bloc/bloc.dart';
import 'package:tahwisa/screens/auth/login.dart';
import 'package:tahwisa/screens/welcome.dart';
import 'package:tahwisa/style/my_colors.dart';
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
  runApp(App(userRepository: UserRepository()));
}

class App extends StatefulWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AuthenticationBloc authenticationBloc;
  UserRepository get userRepository => widget.userRepository;

  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  void initState() {
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

            fontFamily: 'Lato',
            backgroundColor: MyColors.white,
          ),
          builder: (context, child) {
            return BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                if (state is AuthenticationAuthenticated) {
                  _navigator.pushAndRemoveUntil<void>(
                    //HomePage.route(),
                    MaterialPageRoute<void>(
                        builder: (context) => ProfileScreen()),
                    (route) => false,
                  );
                } else if (state is AuthenticationUnauthenticated) {
                  _navigator.pushAndRemoveUntil<void>(
                    //  LoginPage.route(),
                    MaterialPageRoute<void>(
                        builder: (context) =>
                            WelcomeScreen(userRepository: userRepository)),
                    (route) => false,
                  );
                }
              },
              child: child,
            );
          },
          /* home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            cubit: authenticationBloc,
            // ignore: missing_return
            builder: (BuildContext context, AuthenticationState state) {
              if (state is AuthenticationUninitialized) {
                return SplashPage();
                //return WelcomeScreen();
              }
              if (state is AuthenticationAuthenticated) {
                return HomePage();
              }
              if (state is AuthenticationUnauthenticated) {
                //  return LoginPage(userRepository: userRepository);
                return WelcomeScreen(userRepository: userRepository);
              }
              if (state is AuthenticationLoading) {
                return LoadingIndicator();
              }
            },
          ),
          /*routes: {
              //'':
              // '/': (context) => WelcomeScreen(),
              // '/login': (context) => LoginScreen(),
              '/login': (context) =>
                  LoginPage(userRepository: UserRepository()),
              '/sign_up': (context) => SignUPScreen(),
              '/add_place': (context) => AddPlace(),
            })*/*/
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
                WelcomeScreen(userRepository: userRepository));
        break;
      case '/login':
        final page = LoginPage(settings.arguments);
        return MaterialPageRoute(builder: (context) => page);
        break;
      case '/sign_up':
        final page = SignUPScreen(settings.arguments);
        return MaterialPageRoute(builder: (context) => page);

      case '/add_place':
        return MaterialPageRoute(builder: (context) => AddPlace());
    }
  }
}
