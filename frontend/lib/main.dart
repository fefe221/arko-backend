import 'package:flutter/material.dart';
import 'package:frontend/views/login_view.dart';

void main() {
  runApp(const ArkoApp());
}

class ArkoApp extends StatelessWidget {
  const ArkoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arkō Ambiente Planejados',
      debugShowCheckedModeBanner: false, // Tira aquela faixa de "debug"
      theme: ThemeData(
        // Aqui você define as cores do Figma
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Configurando a fonte padrão (exemplo)
        fontFamily: 'Georgia', 
      ),
      home: const LoginView(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ARKŌ'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Bem-vindo ao projeto Arkō.\nO Backend já está conectado!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
