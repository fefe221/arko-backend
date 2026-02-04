import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/views/login_view.dart';
import 'package:frontend/views/dashboard_view.dart';

void main() {
  runApp(const ArkoApp());
}

class ArkoApp extends StatelessWidget {
  const ArkoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arkō Architecture',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        useMaterial3: true, // Garante um visual moderno
      ),
      // O segredo está aqui: o FutureBuilder decide a tela inicial
      home: FutureBuilder<String?>(
        future: AuthService.getToken(),
        builder: (context, snapshot) {
          // Enquanto o Flutter lê o token do storage, mostramos um carregamento
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(color: Colors.black)),
            );
          }

          // Se houver um token, pulamos direto para a Dashboard
          if (snapshot.hasData && snapshot.data != null) {
            return const DashboardView();
          }

          // Se não houver token, o usuário precisa logar
          return const LoginView();
        },
      ),
    );
  }
}
