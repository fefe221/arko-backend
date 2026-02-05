import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/views/public/public_scaffold.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static const _assetPrefix = 'assets/images/background_home_web/';
  static const _displaySeconds = 5;
  static const _fadeDuration = Duration(milliseconds: 4200);

  final List<String> _images = [];
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final keys = manifest
        .listAssets()
        .where((k) => k.startsWith(_assetPrefix))
        .toList()
      ..sort();

    if (!mounted) return;
    setState(() {
      _images
        ..clear()
        ..addAll(keys);
    });

    _timer?.cancel();
    if (_images.length > 1) {
      _timer = Timer.periodic(
        const Duration(seconds: _displaySeconds),
        (_) => setState(() {
          _index = (_index + 1) % _images.length;
        }),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPath = _images.isEmpty ? null : _images[_index];

    return PublicScaffold(
      background: _AnimatedBackground(
        imagePath: currentPath,
        fadeDuration: _fadeDuration,
      ),
      body: Stack(
        children: [
          SizedBox(
            height: 520,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  top: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, "/ambientes"),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 24,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                          backgroundColor: Colors.white.withOpacity(0.45),
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.55),
                            width: 1,
                          ),
                        ),
                        child: const Text("Ambientes"),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () => showDialog(
                          context: context,
                          barrierColor: Colors.black.withOpacity(0.45),
                          builder: (_) => const _HomeOrcamentoModal(),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 24,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                          backgroundColor: Colors.white.withOpacity(0.45),
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.55),
                            width: 1,
                          ),
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
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "Ambientes pensados para bem-estar.",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedBackground extends StatelessWidget {
  const _AnimatedBackground({
    required this.imagePath,
    required this.fadeDuration,
  });

  final String? imagePath;
  final Duration fadeDuration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: fadeDuration,
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          fit: StackFit.expand,
          children: [
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: imagePath == null
          ? const ColoredBox(color: Color(0xFFE8E6DE))
          : _KenBurnsImage(
              key: ValueKey(imagePath),
              imagePath: imagePath!,
            ),
    );
  }
}

class _KenBurnsImage extends StatefulWidget {
  const _KenBurnsImage({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<_KenBurnsImage> createState() => _KenBurnsImageState();
}

class _KenBurnsImageState extends State<_KenBurnsImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Alignment _begin;
  late final Alignment _end;
  late final double _scaleBegin;
  late final double _scaleEnd;

  @override
  void initState() {
    super.initState();
    final rnd = Random(widget.imagePath.hashCode);
    _begin = Alignment(
      rnd.nextDouble() * 0.25 - 0.125,
      rnd.nextDouble() * 0.25 - 0.125,
    );
    _end = Alignment(
      rnd.nextDouble() * 0.25 - 0.125,
      rnd.nextDouble() * 0.25 - 0.125,
    );
    _scaleBegin = 1.04 + rnd.nextDouble() * 0.03;
    _scaleEnd = (_scaleBegin + 0.06).clamp(1.08, 1.16);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final alignment = Alignment.lerp(_begin, _end, t) ?? Alignment.center;
        final scale = _scaleBegin + (_scaleEnd - _scaleBegin) * t;
        return ClipRect(
          child: Transform.scale(
            scale: scale,
            child: Align(
              alignment: alignment,
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        );
      },
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
