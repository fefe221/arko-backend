import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _dio = Dio(); // Cliente para falar com o Go

  Future<void> _fazerLogin() async {
    try {
      // No Docker/Localhost, usamos o IP da sua máquina ou 127.0.0.1
      final response = await _dio.post('http://localhost:8080/login', data: {
        'username': _userController.text,
        'password': _passController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.data['message']), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Falha no login"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400, // Largura fixa para parecer um card no Web
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("ARKŌ", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              TextField(controller: _userController, decoration: const InputDecoration(labelText: "Usuário")),
              TextField(controller: _passController, obscureText: true, decoration: const InputDecoration(labelText: "Senha")),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _fazerLogin,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                child: const Text("Entrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
