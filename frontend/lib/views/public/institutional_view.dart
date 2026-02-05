import 'package:flutter/material.dart';
import 'package:frontend/views/public/public_scaffold.dart';

class InstitutionalView extends StatelessWidget {
  const InstitutionalView({super.key});

  @override
  Widget build(BuildContext context) {
    return PublicScaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          Container(
            height: 320,
            decoration: BoxDecoration(
              color: const Color(0xFFDCD7CC),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF2B2B2B),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "A Arkō",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  "Ambientes planejados para histórias reais.",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Móveis planejados com design,\nprazo e compromisso",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text(
            "Nascemos para alinhar design e arquitetura à rotina das pessoas. "
            "Na Arkō, cada projeto é único, desenvolvido por arquitetos e "
            "acompanhado do primeiro contato à entrega final, com atenção total "
            "aos detalhes, prazos e ao que foi acordado.",
          ),
        ],
      ),
    );
  }
}
