import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
// Importamos o serviço que criamos para salvar o token
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/views/dashboard_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _dio = Dio();

  Future<void> _fazerLogin() async {
    try {
      // 1. Enviamos a requisição ao Backend Go
      final response = await _dio.post('http://localhost:8080/login', data: {
        'username': _userController.text,
        'password': _passController.text,
      });

      // 2. O Go retorna um mapa (JSON). Extraímos o campo 'token'.
      // A estrutura no Go é: {"message": "...", "token": "..."}
      final String tokenGerado = response.data['token'];

      // 3. PERSISTÊNCIA: Chamamos o serviço para gravar o token no storage.
      // Isso é o que garante que o login não se perca no F5.
      await AuthService.saveToken(tokenGerado);

      if (!mounted) return;

      // 4. NAVEGAÇÃO: Se o token foi salvo, levamos o usuário ao painel.
      // Usamos pushReplacement para que ele não consiga "voltar" para a tela de login.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardView()),
      );

    } on DioException catch (e) {
      // Tratamento de erro sênior: verifica se o erro veio do servidor
      String mensagemErro = "Erro ao conectar com o servidor";
      if (e.response?.statusCode == 401) {
        mensagemErro = "Usuário ou senha incorretos";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagemErro), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: Card( // Um card para dar profundidade e elegância
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("ARKŌ", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 4)),
                const SizedBox(height: 10),
                const Text("Área Administrativa", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 32),
                TextField(
                  controller: _userController,
                  decoration: const InputDecoration(labelText: "Usuário", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Senha", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _fazerLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 55),
                  ),
                  child: const Text("ENTRAR"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
