import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/views/login_view.dart';
import 'package:frontend/views/users_management_view.dart';
import 'package:frontend/views/project_management_view.dart';
import 'package:frontend/views/leads_management_view.dart';


class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text("Bem-vindo ao Painel Arkō", style: TextStyle(fontSize: 24))),
    const ProjectsManagementView(), // Esta é a classe que o compilador precisa encontrar
    const UsersManagementView(),
    const LeadsManagementView(),
  ];

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
          NavigationRail(
            backgroundColor: Colors.black87,
            unselectedIconTheme: const IconThemeData(color: Colors.white60),
            selectedIconTheme: const IconThemeData(color: Colors.white),
            unselectedLabelTextStyle: const TextStyle(color: Colors.white60),
            selectedLabelTextStyle: const TextStyle(color: Colors.white),
            labelType: NavigationRailLabelType.all,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.home), label: Text('Início')),
              NavigationRailDestination(icon: Icon(Icons.architecture), label: Text('Projetos')),
              NavigationRailDestination(icon: Icon(Icons.people), label: Text('Equipe')),
              NavigationRailDestination(icon: Icon(Icons.contact_mail), label: Text('Leads')),
            ],
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
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5),
              padding: const EdgeInsets.all(32),
              child: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
