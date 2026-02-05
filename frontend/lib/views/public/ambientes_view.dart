import 'package:flutter/material.dart';
import 'package:frontend/views/public/ambiente_projects_view.dart';
import 'package:frontend/views/public/public_scaffold.dart';

class AmbientesView extends StatelessWidget {
  const AmbientesView({super.key});

  @override
  Widget build(BuildContext context) {
    final ambientes = [
      "Cozinha",
      "Dormitório",
      "Ambientes Integrados",
      "Office e Corporativo",
      "Living",
      "Closet",
      "Salas de Banho",
    ];

    return PublicScaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFDCD7CC), Color(0xFFCFC9BC)],
              ),
            ),
          ),
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            children: [
              Center(
                child: Column(
                  children: ambientes
                      .map(
                        (ambiente) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AmbienteProjectsView(
                                  category: ambiente,
                                ),
                              ),
                            ),
                            child: Text(
                              "/ $ambiente",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontSize: 18),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
