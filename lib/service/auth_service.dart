import 'package:app_login/model/auth_model.dart';
import 'package:app_login/utils/urls.dart';
import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio();
  final Urls _urls = Urls();

  AuthService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (e.response!.statusCode == 401) {
          } else {}
          return handler.next(e);
        },
      ),
    );
  }

  Future<String> login({
    required AuthModel credentions,
  }) async {
    try {
      final response = await _dio.post(
        '${_urls.baseUrl}/users/login',
        data: credentions.toJson(),
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );
      String token = response.data['token'];
      return token;
    } catch (e) {
      rethrow;
    }
  }
}