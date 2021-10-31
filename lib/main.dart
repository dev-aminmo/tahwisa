import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tahwisa/blocs/authentication_bloc/bloc.dart';
import 'package:tahwisa/repositories/place_repository.dart';
import 'package:tahwisa/repositories/user_repository.dart';
import 'package:tahwisa/screens/auth/login.dart';
import 'package:tahwisa/screens/welcome.dart';
import 'package:tahwisa/style/my_colors.dart';

import 'cubits/wish_place_cubit/wish_place_cubit.dart';
import 'repositories/dropdowns_repository.dart';
import 'repositories/fcm_token_repository.dart';
import 'repositories/maps_repository.dart';
import 'repositories/models/place.dart';
import 'repositories/review_repository.dart';
import 'screens/auth/signup.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/views/add_place/add_place_navigator.dart';
import 'screens/profile/views/place_details.dart';
import 'screens/profile/views/rate_place.dart';
import 'screens/profile/views/reviews_screen.dart';

class SimpleBlocDelegate extends BlocObserver {
  /* @override
  void onChange(Cubit cubit, Change change) {
    print(change.toString());

    super.onChange(cubit, change);
  }*/

  @override
  void onEvent(Bloc bloc, Object event) {
    print(event.toString());
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition.toString());
    super.onTransition(bloc, transition);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocDelegate();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  var onTokenRefresh = messaging.onTokenRefresh;
  onTokenRefresh.listen((token) async {
    await SharedPreferences.getInstance()
      ..setString("fcm_token", token);
  });

  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AuthenticationBloc authenticationBloc;
  UserRepository userRepository;
  FcmTokenRepository fcmTokenRepository;
  //PlaceRepository placeRepository;

  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  void initState() {
    userRepository = UserRepository();
    fcmTokenRepository = FcmTokenRepository();
    authenticationBloc = AuthenticationBloc(
        userRepository: userRepository, fcmTokenRepository: fcmTokenRepository);
    authenticationBloc.add(AppStarted());
    // placeRepository = PlaceRepository();
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
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider(create: (_) => PlaceRepository()),
            RepositoryProvider(create: (_) => ReviewRepository()),
            RepositoryProvider(create: (_) => MapsRepository()),
            RepositoryProvider(create: (_) => DropDownsRepository()),
            RepositoryProvider(create: (_) => fcmTokenRepository),
          ],
          child: Builder(
            builder: (ctx) => MultiBlocProvider(
              providers: [
                BlocProvider(
                    create: (_) => WishPlaceCubit(
                        placeRepository: ctx.read<PlaceRepository>())),
                /*    BlocProvider(
                    create: (_) => WishListBloc(
                        placeRepository: ctx.read<PlaceRepository>()))*/
              ],
              child: MaterialApp(
                navigatorKey: _navigatorKey,
                title: 'Tahwisa',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    //primarySwatch: Colors.blue,
                    textTheme: GoogleFonts.latoTextTheme(
                      Theme.of(context).textTheme,
                    ),
                    primaryColor: MyColors.darkBlue,
                    indicatorColor: MyColors.lightGreen,
                    accentColor: MyColors.lightGreen,
                    scaffoldBackgroundColor: MyColors.white,
                    backgroundColor: MyColors.white,
                    // brightness: Brightness.light,
                    appBarTheme: AppBarTheme(
                      brightness: Brightness.dark,
                    )),
                builder: (context, child) {
                  return RepositoryProvider(
                    create: (_) => userRepository,
                    child:
                        BlocListener<AuthenticationBloc, AuthenticationState>(
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
                                builder: (context) => WelcomeScreen()),
                            (route) => false,
                          );
                        }
                      },
                      child: child,
                    ),
                  );
                },
                onGenerateRoute: _getRoute,
              ),
            ),
          ),
        ));
  }

  Route _getRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => SplashPage());
        break;
      case '/home':
        return MaterialPageRoute(builder: (context) => WelcomeScreen());
        break;
      case '/login':
        return MaterialPageRoute(builder: (context) => LoginPage());
        break;
      case '/sign_up':
        return MaterialPageRoute(builder: (context) => SignUPScreen());
      case '/add_place_navigator':
        return MaterialPageRoute(builder: (context) => AddPlaceNavigator());
      case PlaceDetailsScreen.routeName:
        Map<String, dynamic> arguments =
            new Map<String, dynamic>.from(settings.arguments);
        return PlaceDetailsScreen.route(
          place: arguments['place'] as Place,
          heroAnimationTag: arguments['heroAnimationTag'],
          placeId: arguments['placeId'],
        );
      case RatePlaceScreen.routeName:
        Map<String, dynamic> arguments =
            new Map<String, dynamic>.from(settings.arguments);
        return RatePlaceScreen.route(
          initialRate: arguments['initialRate'],
          userReviewCubit: arguments['userReviewCubit'],
          initialComment: arguments['initialComment'],
        );
      case ReviewsScreen.routeName:
        Map<String, dynamic> arguments =
            new Map<String, dynamic>.from(settings.arguments);
        return ReviewsScreen.route(
          reviewsCubit: arguments['reviewsCubit'],
        );
    }
  }
}
