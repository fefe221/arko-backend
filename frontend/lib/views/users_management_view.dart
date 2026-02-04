import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:frontend/services/user_service.dart';

class UsersManagementView extends StatefulWidget {
  const UsersManagementView({super.key});

  @override
  State<UsersManagementView> createState() => _UsersManagementViewState();
}

class _UsersManagementViewState extends State<UsersManagementView> {
  final UserService _userService = UserService();
  late Future<List<dynamic>> _usersFuture;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  // Didática: Função central para atualizar a lista chamando o Backend
  void _loadUsers() {
    setState(() {
      _usersFuture = _userService.getCollaborators();
    });
  }

  // Didática: Abre o modal para criação de novo usuário (O "C" do CRUD)
  void _showCreateUserModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Novo Colaborador"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: "Usuário"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Senha"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () async {
                try {
                  await _userService.createUser(
                    _usernameController.text,
                    _passwordController.text,
                  );
                  if (!mounted) return;
                  Navigator.pop(context);
                  _usernameController.clear();
                  _passwordController.clear();
                  _loadUsers(); // Recarrega a lista após criar
                } catch (e) {
                  _showErrorSnackBar("Erro ao criar: $e");
                }
              },
              child: const Text("Salvar", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Didática: Abre o modal de confirmação para exclusão (O "D" do CRUD)
  void _confirmDelete(int userId, String username) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Excluir Colaborador"),
          content: Text("Deseja realmente remover $username?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                try {
                  await _userService.deleteUser(userId);
                  if (!mounted) return;
                  Navigator.pop(context);
                  _loadUsers(); // Recarrega a lista após deletar
                  _showSuccessSnackBar("Colaborador removido.");
                } catch (e) {
                  _showErrorSnackBar("Erro ao deletar: $e");
                }
              },
              child: const Text("Excluir", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showErrorSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cabeçalho da View
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Equipe Arkō", 
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ElevatedButton.icon(
              onPressed: _showCreateUserModal,
              icon: const Icon(Icons.add),
              label: const Text("Novo Colaborador"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        // Lista de Usuários vinda do Backend
        Expanded(
          child: FutureBuilder<List<dynamic>>(
            future: _usersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.black));
              }
              if (snapshot.hasError) return const Center(child: Text("Erro ao carregar dados."));

              final users = snapshot.data ?? [];
              if (users.isEmpty) return const Center(child: Text("Nenhum colaborador."));

              return ListView.separated(
                itemCount: users.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final user = users[index];
                  // Didática: Aqui o 'user' está definido, então podemos usá-lo com segurança
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(user['username'].toString().toUpperCase(), 
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("ID: ${user['id']}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _confirmDelete(user['id'], user['username']),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
