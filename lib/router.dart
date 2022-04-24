import 'package:flutter/material.dart';
import 'package:tahwisa/src/repositories/models/place.dart';
import 'package:tahwisa/src/screens/auth/login.dart';
import 'package:tahwisa/src/screens/auth/signup.dart';
import 'package:tahwisa/src/screens/profile/views/add_place/add_place_navigator.dart';
import 'package:tahwisa/src/screens/profile/views/notification/notification_place_added.dart';
import 'package:tahwisa/src/screens/profile/views/notification/notification_place_refused.dart';
import 'package:tahwisa/src/screens/profile/views/place_details.dart';
import 'package:tahwisa/src/screens/profile/views/rate_place.dart';
import 'package:tahwisa/src/screens/profile/views/reviews_screen.dart';
import 'package:tahwisa/src/screens/profile/views/update_place.dart';
import 'package:tahwisa/src/screens/welcome.dart';

class MyRouter {
  static Route getRoute(RouteSettings settings) {
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
