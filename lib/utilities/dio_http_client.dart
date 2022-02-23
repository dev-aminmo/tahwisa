import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tahwisa/blocs/authentication_bloc/bloc.dart';
import 'package:tahwisa/repositories/api/api_endpoints.dart';

class DioHttpClient {
  static Dio? _dio;
  static void initialDio(AuthenticationBloc? _authenticationBloc) {
    _dio = Dio(
      BaseOptions(
        baseUrl: Api.baseUrl,
      ),
    );
    _dio!.interceptors.clear();
    _dio!.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
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
    }));
  }

  static Dio? get dio => _dio;
}
