import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/services/auth_service.dart';

class ApiClient {
  // Configuração base com timeout para não ficar travado
  late final Dio dio;

  ApiClient() {
    final baseUrl = resolveBaseUrl();
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
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

  static String resolveBaseUrl() {
    if (!kIsWeb) {
      return 'http://localhost:8080';
    }
    // Em produção (release), força o domínio atual
    if (kReleaseMode) {
      return Uri.base.origin;
    }
    // Em dev web, permite backend local
    final origin = Uri.base.origin;
    final host = Uri.base.host;
    if (host == 'localhost' || host == '127.0.0.1') {
      return 'http://localhost:8080';
    }
    return origin;
  }
}
