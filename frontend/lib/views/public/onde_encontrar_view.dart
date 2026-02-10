import 'package:flutter/material.dart';
import 'package:frontend/views/public/public_scaffold.dart';

class OndeEncontrarView extends StatelessWidget {
  const OndeEncontrarView({super.key});

  @override
  Widget build(BuildContext context) {
    return PublicScaffold(
      body: ListView(
        children: [
          Text(
            "Onde encontrar",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Container(
            height: 240,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/images/Fachada.jpg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black12.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Loja Arkō", style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text("Ambientes planejados"),
                SizedBox(height: 12),
                Text("Rua Georgetown, 60"),
                Text("Londrina / PR"),
                SizedBox(height: 12),
                Text("Seg-sex, 9h às 19h | Sáb, 8h às 12h"),
                Text("tel.: 43 99146-6424"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
