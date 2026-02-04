import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/views/login_view.dart';
import 'package:frontend/views/users_management_view.dart'; // Importamos a tela de usuários

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  // 1. Variável de Estado: Controla qual índice do menu está ativo
  int _selectedIndex = 0;

  // 2. Lista de Telas: Aqui definimos o que aparece no centro da dashboard
  // Cada índice aqui corresponde a um botão no menu lateral
  final List<Widget> _pages = [
    const Center(child: Text("Bem-vindo ao Início", style: TextStyle(fontSize: 24))),
    const Center(child: Text("Módulo de Projetos - Em breve", style: TextStyle(fontSize: 24))),
    const UsersManagementView(), // <-- A tela que criamos no passo anterior
    const Center(child: Text("Módulo de Leads - Em breve", style: TextStyle(fontSize: 24))),
  ];

  // 3. Função de Logout (Lógica Sênior de limpeza)
  void _handleLogout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // MENU LATERAL (Sidebar)
          NavigationRail(
            backgroundColor: Colors.black87,
            unselectedIconTheme: const IconThemeData(color: Colors.white60),
            selectedIconTheme: const IconThemeData(color: Colors.white),
            unselectedLabelTextStyle: const TextStyle(color: Colors.white60),
            selectedLabelTextStyle: const TextStyle(color: Colors.white),
            
            // Define se o menu mostra ícone ou texto
            labelType: NavigationRailLabelType.all,
            
            // 4. Integração do Estado: Qual item está marcado como ativo?
            selectedIndex: _selectedIndex,
            
            // 5. Mudança de Estado: O que acontece ao clicar?
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index; // O Flutter redesenha a tela com o novo índice
              });
            },
            
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.home), label: Text('Início')),
              NavigationRailDestination(icon: Icon(Icons.architecture), label: Text('Projetos')),
              NavigationRailDestination(icon: Icon(Icons.people), label: Text('Equipe')), // Index 2
              NavigationRailDestination(icon: Icon(Icons.contact_mail), label: Text('Leads')),
            ],
            
            // Botão de Sair posicionado ao final do menu
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white60),
                    onPressed: _handleLogout,
                  ),
                ),
              ),
            ),
          ),

          // CONTEÚDO PRINCIPAL (Dinâmico)
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5),
              padding: const EdgeInsets.all(32),
              // 6. O segredo da troca de telas:
              // Ele exibe o Widget que estiver na posição _selectedIndex da lista _pages
              child: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
