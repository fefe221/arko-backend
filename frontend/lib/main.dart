import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/views/dashboard_view.dart';
import 'package:frontend/views/login_view.dart';
import 'package:frontend/views/public/ambientes_view.dart';
import 'package:frontend/views/public/campanhas_view.dart';
import 'package:frontend/views/public/home_view.dart';
import 'package:frontend/views/public/institutional_view.dart';
import 'package:frontend/views/public/onde_encontrar_view.dart';
import 'package:frontend/views/public/landing_pages/lp01_view.dart';
import 'package:frontend/views/public/landing_pages/lp02_view.dart';
import 'package:frontend/views/public/landing_pages/lp03_view.dart';

void main() {
  runApp(const ArkoApp());
}

class ArkoApp extends StatelessWidget {
  const ArkoApp({super.key});

  static const _bgColor = Color(0xFFE8E6DE);
  static const _textPrimary = Color(0xFF686868);
  static const _textSecondary = Color(0xFF8A8A8A);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arkō Architecture',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Birken Nue',
        scaffoldBackgroundColor: _bgColor,
        colorScheme: const ColorScheme.light(
          primary: _textPrimary,
          onPrimary: _bgColor,
          surface: _bgColor,
          onSurface: _textPrimary,
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
            color: _textPrimary,
          ),
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.48,
            color: _textPrimary,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: _textSecondary,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: _textPrimary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: _textPrimary, width: 1),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeView(),
        '/institucional': (_) => const InstitutionalView(),
        '/ambientes': (_) => const AmbientesView(),
        '/campanhas': (_) => const _CampanhasGate(),
        '/onde_encontrar': (_) => const OndeEncontrarView(),
        '/lp01': (_) => const Lp01View(),
        '/lp02': (_) => const Lp02View(),
        '/lp03': (_) => const Lp03View(),
        '/login': (_) => const LoginView(),
        '/admin': (_) => const _AdminGate(),
      },
    );
  }
}

class _AdminGate extends StatelessWidget {
  const _AdminGate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: AuthService.getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
          return const DashboardView();
        }

        return const LoginView();
      },
    );
  }
}

class _CampanhasGate extends StatelessWidget {
  const _CampanhasGate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: AuthService.getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
          return const CampanhasView();
        }

        return const LoginView();
      },
    );
  }
}
