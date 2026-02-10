import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/orcamento_modal.dart';

class PublicScaffold extends StatefulWidget {
  const PublicScaffold({
    super.key,
    required this.body,
    this.showDivider = false,
    this.background,
    this.applyContentPadding = true,
    this.scrollHeader = false,
  });

  final Widget body;
  final bool showDivider;
  final Widget? background;
  final bool applyContentPadding;
  final bool scrollHeader;

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
      builder: (_) => const OrcamentoModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget header = SafeArea(
      bottom: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 900;
          final horizontal = isMobile ? 20.0 : 150.0;
          final logoHeight = isMobile ? 62.0 : 120.0;
          final bottomPadding = isMobile ? 20.0 : 24.0;
          final topPadding = isMobile ? 60.0 : 90.0;
          return Padding(
            padding:
                EdgeInsets.fromLTRB(horizontal, topPadding, horizontal, bottomPadding),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu, color: _textPrimary),
                  iconSize: 30,
                  onPressed: _toggleMenu,
                ),
                const Spacer(),
                InkWell(
                  onTap: () => _navigateTo("/"),
                  child: SizedBox(
                    height: logoHeight,
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: logoHeight,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: "Área administrativa",
                  onPressed: () => _navigateTo("/login"),
                  icon: const Icon(Icons.lock_outline, color: _textPrimary),
                  iconSize: 28,
                ),
              ],
            ),
          );
        },
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          if (widget.background != null)
            Positioned.fill(child: widget.background!),
          widget.scrollHeader
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      header,
                      if (widget.showDivider) const Divider(height: 1),
                      if (!widget.applyContentPadding)
                        widget.body
                      else
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isMobile = constraints.maxWidth < 900;
                            final horizontal = isMobile ? 20.0 : 150.0;
                            final top = isMobile ? 60.0 : 80.0;
                            return Padding(
                              padding:
                                  EdgeInsets.fromLTRB(horizontal, top, horizontal, 24),
                              child: widget.body,
                            );
                          },
                        ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    header,
                    if (widget.showDivider) const Divider(height: 1),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          if (!widget.applyContentPadding) {
                            return widget.body;
                          }
                          final isMobile = constraints.maxWidth < 900;
                          final horizontal = isMobile ? 20.0 : 150.0;
                          final top = isMobile ? 60.0 : 80.0;
                          return Padding(
                            padding:
                                EdgeInsets.fromLTRB(horizontal, top, horizontal, 24),
                            child: widget.body,
                          );
                        },
                      ),
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
                              FutureBuilder<String?>(
                                future: AuthService.getToken(),
                                builder: (context, snapshot) {
                                  final hasToken = snapshot.hasData &&
                                      snapshot.data != null &&
                                      snapshot.data!.isNotEmpty;
                                  if (!hasToken) {
                                    return const SizedBox.shrink();
                                  }
                                  return _MenuItem(
                                    label: "03 / Campanhas",
                                    onTap: () => _navigateTo("/campanhas"),
                                  );
                                },
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
