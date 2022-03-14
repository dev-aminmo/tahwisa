import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tahwisa/app/blocs/authentication_bloc/bloc.dart';
import 'package:tahwisa/app/repositories/api/api_endpoints.dart';
import 'package:tahwisa/app/utilities/dio_interceptor.dart';

class DioHttpClient {
  static Dio? _dio;

  static void initialDio(AuthenticationBloc? _authenticationBloc) {
    _dio = Dio(
      BaseOptions(
        baseUrl: Api.baseUrl,
        validateStatus: (status) => true,
      ),
    );
    _dio!.interceptors.clear();
    _dio!.interceptors.add(MyDioInterceptor.interceptor(_authenticationBloc));
  }

  static Future<Response> getWithHeader(String url) async {
    var pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? '-1';
    return _dio!.get(url,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer " + token
          },
        ));
  }

  static Future<Response> postWithHeader(String url, {body}) async {
    var pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? '-1';
    return _dio!.post(url,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer " + token
          },
        ),
        data: body);
  }

  static Future<Response> deleteWithHeader(String url) async {
    var pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? '-1';
    return _dio!.delete(url,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer " + token
          },
        ));
  }

  static Future<Response> post(String url, {body}) async {
    return _dio!.post(url,
        options: Options(
          headers: {
            "Accept": "application/json",
          },
        ),
        data: body);
  }
}
