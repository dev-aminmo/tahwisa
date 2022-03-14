import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tahwisa/app/blocs/authentication_bloc/bloc.dart';

class MyDioInterceptor {
  static interceptor(_authenticationBloc) {
    return InterceptorsWrapper(onRequest: (options, handler) async {
      var pref = await SharedPreferences.getInstance();
      String token = pref.getString("token")!;
      options.headers['Authorization'] = "Bearer " + token;
      return handler.next(options);
    }, onResponse: (response, handler) {
      if (response.statusCode == 401) {
        _authenticationBloc!.add(LoggedOut());
      }
      if (response != null) {
        return handler.next(response);
      } else {
        return null;
      }
    }, onError: (DioError e, handler) async {
      if (e.response!.statusCode == 401) {
        _authenticationBloc!.add(LoggedOut());
      }
    });
  }
}
