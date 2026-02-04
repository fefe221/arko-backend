import 'package:dio/dio.dart';
import 'package:frontend/services/auth_service.dart';

class ApiClient {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'));

  ApiClient() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Busca o token que salvamos no login
          final token = await AuthService.getToken();
          
          if (token != null) {
            // Adiciona o token no padrão Bearer (padrão de mercado)
            options.headers['Authorization'] = token;
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Se o servidor responder 401 (token expirado), podemos deslogar o usuário
          if (e.response?.statusCode == 401) {
            AuthService.logout();
          }
          return handler.next(e);
        },
      ),
    );
  }
}
