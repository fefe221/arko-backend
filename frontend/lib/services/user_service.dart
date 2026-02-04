import 'package:frontend/services/api_client.dart';

class UserService {
  final ApiClient _api = ApiClient();

  // Busca a lista de colaboradores do Go
  Future<List<dynamic>> getCollaborators() async {
    try {
      final response = await _api.dio.get('/admin/users');
      return response.data; // Retorna a lista de usuários [{id, username}, ...]
    } catch (e) {
      throw Exception("Falha ao carregar colaboradores");
    }
  }

  // Cria um novo colaborador
  Future<void> createUser(String username, String password) async {
    try {
      await _api.dio.post('/admin/users', data: {
        'username': username,
        'password': password,
      });
    } catch (e) {
      throw Exception("Falha ao criar colaborador");
    }
  }
  // Deleta um colaborador passando o ID
  Future<void> deleteUser(int id) async {
    try {
      // Passamos o ID na URL, conforme configurado no Go
      await _api.dio.delete('/admin/users/$id');
    } catch (e) {
      throw Exception("Erro ao excluir colaborador");
  }
}
}
