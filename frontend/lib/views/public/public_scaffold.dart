import 'package:flutter/material.dart';

class PublicScaffold extends StatefulWidget {
  const PublicScaffold({
    super.key,
    required this.body,
    this.showDivider = false,
  });

  final Widget body;
  final bool showDivider;

  @override
  State<PublicScaffold> createState() => _PublicScaffoldState();
}

class _PublicScaffoldState extends State<PublicScaffold> {
  bool _menuOpen = false;

  static const _textPrimary = Color(0xFF686868);
  static const _textSecondary = Color(0xFF8A8A8A);
  static const _panelBg = Color(0xFFE8E6DE);

  void _toggleMenu() {
    setState(() {
      _menuOpen = !_menuOpen;
    });
  }

  void _navigateTo(String route) {
    setState(() {
      _menuOpen = false;
    });
    Navigator.pushNamed(context, route);
  }

  void _openOrcamento() {
    setState(() {
      _menuOpen = false;
    });
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (_) => const _OrcamentoModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu, color: _textPrimary),
                        onPressed: _toggleMenu,
                      ),
                      const Spacer(),
                      const Text(
                        "AR\nKŌ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          height: 1,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                          color: _textPrimary,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: "Área administrativa",
                        onPressed: () => _navigateTo("/login"),
                        icon: const Icon(Icons.lock_outline, color: _textPrimary),
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.showDivider) const Divider(height: 1),
              Expanded(
                child: widget.body,
              ),
            ],
          ),
          if (_menuOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleMenu,
                child: Container(
                  color: Colors.black.withOpacity(0.25),
                ),
              ),
            ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            left: _menuOpen ? 0 : -280,
            top: 0,
            bottom: 0,
            child: Container(
              width: 260,
              color: _panelBg,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: _textPrimary),
                        onPressed: _toggleMenu,
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _MenuItem(
                                label: "01 / Home",
                                onTap: () => _navigateTo("/"),
                              ),
                              _MenuItem(
                                label: "02 / A Experiência Arkō",
                                onTap: () => _navigateTo("/institucional"),
                              ),
                              _MenuItem(
                                label: "03 / Campanhas",
                                onTap: () => _navigateTo("/campanhas"),
                              ),
                              _MenuItem(
                                label: "04 / Ambientes",
                                onTap: () => _navigateTo("/ambientes"),
                              ),
                              _MenuItem(
                                label: "05 / Onde encontrar",
                                onTap: () => _navigateTo("/onde_encontrar"),
                              ),
                              _MenuItem(
                                label: "06 / Solicite orçamento",
                                onTap: _openOrcamento,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "contato@arko.com.br",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: _textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  static const _textPrimary = Color(0xFF686868);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: _textPrimary,
          padding: EdgeInsets.zero,
          alignment: Alignment.centerLeft,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        child: Text(label),
      ),
    );
  }
}

class _OrcamentoModal extends StatelessWidget {
  const _OrcamentoModal();

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
