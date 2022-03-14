import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tahwisa/app/blocs/authentication_bloc/bloc.dart';
import 'package:tahwisa/app/cubits/wish_place_cubit/wish_place_cubit.dart';
import 'package:tahwisa/app/repositories/admin_repository.dart';
import 'package:tahwisa/app/repositories/dropdowns_repository.dart';
import 'package:tahwisa/app/repositories/fcm_token_repository.dart';
import 'package:tahwisa/app/repositories/maps_repository.dart';
import 'package:tahwisa/app/repositories/notification_repository.dart';
import 'package:tahwisa/app/repositories/place_repository.dart';
import 'package:tahwisa/app/repositories/refuse_place_message_repository.dart';
import 'package:tahwisa/app/repositories/review_repository.dart';
import 'package:tahwisa/app/repositories/user_repository.dart';
import 'package:tahwisa/app/screens/profile/profile_screen.dart';
import 'package:tahwisa/app/screens/welcome.dart';
import 'package:tahwisa/app/style/my_colors.dart';
import 'package:tahwisa/app/utilities/dio_http_client.dart';
import 'package:tahwisa/router.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
                theme: _getTheme(),
                builder: (context, child) {
                  return RepositoryProvider(
                    create: (_) => userRepository,
                    child: _buildAuthenticationBlocListener(child),
                  );
                },
                onGenerateRoute: MyRouter.getRoute,
              ),
            ),
          ),
        ));
  }

  BlocListener _buildAuthenticationBlocListener(child) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationAuthenticated) {
          _navigator?.pushAndRemoveUntil<void>(
            MaterialPageRoute<void>(builder: (context) => ProfileScreen()),
            (route) => false,
          );
        } else if (state is AuthenticationUnauthenticated) {
          _navigator?.pushAndRemoveUntil<void>(
            MaterialPageRoute<void>(builder: (context) => WelcomeScreen()),
            (route) => false,
          );
        }
      },
      child: child,
    );
  }

  ThemeData _getTheme() {
    return ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryColor: MyColors.darkBlue,
        indicatorColor: MyColors.lightGreen,
        scaffoldBackgroundColor: MyColors.white,
        backgroundColor: MyColors.white,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ));
  }
}
