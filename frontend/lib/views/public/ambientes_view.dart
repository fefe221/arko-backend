import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/views/public/ambiente_projects_view.dart';
import 'package:frontend/views/public/public_scaffold.dart';

class AmbientesView extends StatefulWidget {
  const AmbientesView({super.key});

  @override
  State<AmbientesView> createState() => _AmbientesViewState();
}

class _AmbientesViewState extends State<AmbientesView>
    with SingleTickerProviderStateMixin {
  static const _switchDuration = Duration(milliseconds: 250);
  late final AnimationController _flashController;
  bool _isLit = false;

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _startSequenceWithDelay();
  }

  Future<void> _startSequenceWithDelay() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    setState(() => _isLit = true);
    await _flashController.forward(from: 0);
    if (!mounted) return;
    await _flashController.reverse();
    if (!mounted) return;
    // Mantém a imagem "acesa" após o efeito
    setState(() => _isLit = true);
  }

  Future<void> _runLightSequence() async {
    if (!mounted) return;
    setState(() => _isLit = true);
    await _flashController.forward(from: 0);
    if (!mounted) return;
    await _flashController.reverse();
    if (!mounted) return;
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isLit = false);
  }

  @override
  void dispose() {
    _flashController.dispose();
    super.dispose();
  }

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
      background: Positioned.fill(
        child: AnimatedSwitcher(
          duration: _switchDuration,
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 900;
              final offImage = isMobile
                  ? 'assets/images/background_ambiente_mobile/background_ambiente01.png'
                  : 'assets/images/background_ambiente_web/background_ambiente01.png';
              final onImage = isMobile
                  ? 'assets/images/background_ambiente_mobile/background_ambiente02.png'
                  : 'assets/images/background_ambiente_web/background_ambiente02.png';
              return _isLit
                  ? _LightImage(
                      key: ValueKey('lit-$isMobile'),
                      imagePath: onImage,
                      flash: _flashController,
                    )
                  : SizedBox.expand(
                      key: ValueKey('off-$isMobile'),
                      child: Image.asset(
                        offImage,
                        fit: BoxFit.cover,
                      ),
                    );
            },
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ambientes
                  .map(
                    (ambiente) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _AmbienteLink(
                        label: ambiente,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AmbienteProjectsView(
                              category: ambiente,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}

class _AmbienteLink extends StatefulWidget {
  const _AmbienteLink({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  State<_AmbienteLink> createState() => _AmbienteLinkState();
}

class _AmbienteLinkState extends State<_AmbienteLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context)
        .textTheme
        .titleLarge
        ?.copyWith(fontSize: 18, color: Colors.white);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            style: baseStyle?.copyWith(
                  color: _hovered ? Colors.white.withOpacity(0.85) : Colors.white,
                  letterSpacing: _hovered ? 0.6 : 0.2,
                ) ??
                const TextStyle(color: Colors.white),
            child: Text("/ ${widget.label}"),
          ),
        ),
      ),
    );
  }
}

class _LightImage extends StatelessWidget {
  const _LightImage({
    super.key,
    required this.imagePath,
    required this.flash,
  });

  final String imagePath;
  final Animation<double> flash;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: flash,
      builder: (context, _) {
        final boost = 40 * flash.value;
        final matrix = <double>[
          1, 0, 0, 0, boost.toDouble(),
          0, 1, 0, 0, boost.toDouble(),
          0, 0, 1, 0, boost.toDouble(),
          0, 0, 0, 1, 0,
        ];
        return SizedBox.expand(
          child: ColorFiltered(
            colorFilter: ColorFilter.matrix(matrix),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
