import 'package:dio/dio.dart';
import 'package:frontend/services/auth_service.dart';

class ApiClient {
  // Configuração base com timeout para não ficar travado
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));


ApiClient() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Garante a recuperação do token do storage antes de cada chamada
          final token = await AuthService.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = token;
          }
          // Evita quebrar upload multipart; o Dio define o Content-Type correto
          if (options.data is! FormData) {
            options.headers['Content-Type'] = 'application/json';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
            AuthService.logout();
          }
          return handler.next(e);
        },
      ),
    );
  }
}
