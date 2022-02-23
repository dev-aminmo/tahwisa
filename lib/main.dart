import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tahwisa/blocs/authentication_bloc/bloc.dart';
import 'package:tahwisa/repositories/notification_repository.dart';
import 'package:tahwisa/repositories/place_repository.dart';
import 'package:tahwisa/repositories/user_repository.dart';
import 'package:tahwisa/screens/auth/login.dart';
import 'package:tahwisa/screens/welcome.dart';
import 'package:tahwisa/style/my_colors.dart';
import 'package:tahwisa/utilities/dio_http_client.dart';

import 'cubits/wish_place_cubit/wish_place_cubit.dart';
import 'repositories/admin_repository.dart';
import 'repositories/dropdowns_repository.dart';
import 'repositories/fcm_token_repository.dart';
import 'repositories/maps_repository.dart';
import 'repositories/models/place.dart';
import 'repositories/refuse_place_message_repository.dart';
import 'repositories/review_repository.dart';
import 'screens/auth/signup.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/views/add_place/add_place_navigator.dart';
import 'screens/profile/views/notification/notification_place_added.dart';
import 'screens/profile/views/notification/notification_place_refused.dart';
import 'screens/profile/views/place_details.dart';
import 'screens/profile/views/rate_place.dart';
import 'screens/profile/views/reviews_screen.dart';
import 'screens/profile/views/update_place.dart';

class SimpleBlocDelegate extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    print(event?.toString());
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
  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late AuthenticationBloc authenticationBloc;
  late UserRepository userRepository;
  late FcmTokenRepository fcmTokenRepository;
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState? get _navigator => _navigatorKey.currentState;

  @override
  void initState() {
    super.initState();
    userRepository = UserRepository();
    fcmTokenRepository = FcmTokenRepository();
    authenticationBloc = AuthenticationBloc(
        userRepository: userRepository, fcmTokenRepository: fcmTokenRepository);

    DioHttpClient.initialDio(authenticationBloc);
    authenticationBloc.add(AppStarted());
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
            RepositoryProvider(create: (_) => NotificationRepository()),
            RepositoryProvider(create: (_) => AdminRepository()),
            RepositoryProvider(create: (_) => RefusePlaceMessageRepository()),
          ],
          child: Builder(
            builder: (ctx) => MultiBlocProvider(
              providers: [
                BlocProvider(
                    create: (_) => WishPlaceCubit(
                        placeRepository: ctx.read<PlaceRepository>())),
              ],
              child: MaterialApp(
                navigatorKey: _navigatorKey,
                title: 'Tahwisa',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    textTheme: GoogleFonts.latoTextTheme(
                      Theme.of(context).textTheme,
                    ),
                    primaryColor: MyColors.darkBlue,
                    indicatorColor: MyColors.lightGreen,
                    scaffoldBackgroundColor: MyColors.white,
                    backgroundColor: MyColors.white,
                    appBarTheme: AppBarTheme(
                      systemOverlayStyle: SystemUiOverlayStyle.light,
                    )),
                builder: (context, child) {
                  return RepositoryProvider(
                    create: (_) => userRepository,
                    child:
                        BlocListener<AuthenticationBloc, AuthenticationState>(
                      listener: (context, state) {
                        if (state is AuthenticationAuthenticated) {
                          _navigator?.pushAndRemoveUntil<void>(
                            //HomePage.route(),
                            MaterialPageRoute<void>(
                                builder: (context) => ProfileScreen()),
                            (route) => false,
                          );
                        } else if (state is AuthenticationUnauthenticated) {
                          _navigator?.pushAndRemoveUntil<void>(
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
      case '/home':
        return MaterialPageRoute(builder: (context) => WelcomeScreen());
      case '/login':
        return MaterialPageRoute(builder: (context) => LoginPage());
      case '/sign_up':
        return MaterialPageRoute(builder: (context) => SignUPScreen());
      case '/add_place_navigator':
        return MaterialPageRoute(builder: (context) => AddPlaceNavigator());
      case PlaceDetailsScreen.routeName:
        Map<String, dynamic> arguments = new Map<String, dynamic>.from(
            settings.arguments as Map<dynamic, dynamic>);
        return PlaceDetailsScreen.route(
          place: arguments['place'] as Place,
          heroAnimationTag: arguments['heroAnimationTag'],
          placeId: arguments['placeId'],
        );
      case UpdatePlaceScreen.routeName:
        Map<String, dynamic> arguments = new Map<String, dynamic>.from(
            settings.arguments as Map<dynamic, dynamic>);
        return UpdatePlaceScreen.route(
          placeId: arguments['placeId'],
        );
      case RatePlaceScreen.routeName:
        Map<String, dynamic> arguments = new Map<String, dynamic>.from(
            settings.arguments as Map<dynamic, dynamic>);
        return RatePlaceScreen.route(
          initialRate: arguments['initialRate'],
          userReviewCubit: arguments['userReviewCubit'],
          initialComment: arguments['initialComment'],
        );
      case ReviewsScreen.routeName:
        Map<String, dynamic> arguments = new Map<String, dynamic>.from(
            settings.arguments as Map<dynamic, dynamic>);
        return ReviewsScreen.route(
          reviewsCubit: arguments['reviewsCubit'],
        );
      case NotificationPlaceAdded.routeName:
        Map<String, dynamic> arguments = new Map<String, dynamic>.from(
            settings.arguments as Map<dynamic, dynamic>);
        return NotificationPlaceAdded.route(
            notificationBloc: arguments['notificationBloc'],
            notification: arguments['notification']);
      case NotificationPlaceRefused.routeName:
        Map<String, dynamic> arguments = new Map<String, dynamic>.from(
            settings.arguments as Map<dynamic, dynamic>);
        return NotificationPlaceRefused.route(
            notification: arguments['notification']);
      default:
        return MaterialPageRoute(builder: (context) => LoginPage());
    }
  }
}
