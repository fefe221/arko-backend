import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/views/login_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  // Função para deslogar
  void _handleLogout(BuildContext context) async {
    await AuthService.logout(); // Limpa o token do storage
    if (!context.mounted) return;
    
    // Volta para a tela de login removendo todas as rotas anteriores
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 1. Menu Lateral (Sidebar)
          Container(
            width: 250,
            color: Colors.black87,
            child: Column(
              children: [
                const DrawerHeader(
                  child: Center(
                    child: Text(
                      "ARKŌ",
                      style: TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 8),
                    ),
                  ),
                ),
                _buildMenuItem(Icons.dashboard, "Início", () {}),
                _buildMenuItem(Icons.architecture, "Projetos", () {}),
                _buildMenuItem(Icons.contact_mail, "Leads (Contatos)", () {}),
                const Spacer(), // Empurra o logout para o final
                _buildMenuItem(Icons.logout, "Sair", () => _handleLogout(context)),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // 2. Área de Conteúdo Principal
          Expanded(
            child: Container(
              color: const Color(0xFFFF0F0), // Fundo levemente cinza
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Painel de Controle",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text("Gerencie os projetos e leads da Arkō Architecture."),
                  const SizedBox(height: 40),
                  
                  // Cards de resumo (Simulados por enquanto)
                  Row(
                    children: [
                      _buildStatCard("Leads Hoje", "04", Colors.blueAccent),
                      const SizedBox(width: 20),
                      _buildStatCard("Projetos", "12", Colors.black87),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para itens do menu
  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(label, style: const TextStyle(color: Colors.white70)),
      onTap: onTap,
      hoverColor: Colors.white10,
    );
  }

  // Widget auxiliar para os cards de estatística
  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
