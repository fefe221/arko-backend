import 'package:flutter/material.dart';
import 'package:frontend/views/public/public_scaffold.dart';

class CampanhasView extends StatelessWidget {
  const CampanhasView({super.key});

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
          Text(
            "Campanhas",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            "Promoções e condições especiais em destaque.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          ...List.generate(
            3,
            (index) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Condição especial ${index + 1}",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Detalhes da campanha serão adicionados aqui.",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
