import 'package:flutter/material.dart';
import 'package:frontend/views/public/public_scaffold.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return PublicScaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          Container(
            height: 520,
            decoration: BoxDecoration(
              color: const Color(0xFFDCD7CC),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 24,
                  top: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, "/ambientes"),
                        child: const Text("Ambientes"),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () => showDialog(
                          context: context,
                          barrierColor: Colors.black.withOpacity(0.35),
                          builder: (_) => const _HomeOrcamentoModal(),
                        ),
                        child: const Text("Solicitar orçamento"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Ambientes pensados para bem-estar.",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}

class _HomeOrcamentoModal extends StatelessWidget {
  const _HomeOrcamentoModal();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: const Color(0xFFE8E6DE),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Como você prefere iniciar seu projeto?",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {},
              child: const Text("whatsapp"),
            ),
            const SizedBox(height: 12),
            Text(
              "Ideal para dúvidas rápidas\ne agendamento imediato.",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              children: const [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text("ou"),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Preencha o formulário e um dos nossos\nArquitetos irá entrar em contato.",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const _Input(label: "Nome"),
            const SizedBox(height: 10),
            const _Input(label: "Telefone"),
            const SizedBox(height: 10),
            const _Input(label: "E-mail"),
            const SizedBox(height: 10),
            const _Input(label: "Qual ambiente pretende planejar?"),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Enviar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Input extends StatelessWidget {
  const _Input({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
