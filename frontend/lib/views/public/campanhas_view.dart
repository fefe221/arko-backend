import 'package:flutter/material.dart';
import 'package:frontend/views/public/public_scaffold.dart';

class CampanhasView extends StatelessWidget {
  const CampanhasView({super.key});

  @override
  Widget build(BuildContext context) {
    return PublicScaffold(
      body: ListView(
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
          _CampaignLink(
            label: "Atendimento prioritario",
            route: "/lp01",
          ),
          const SizedBox(height: 16),
          _CampaignLink(
            label: "Projeto gratis",
            route: "/lp02",
          ),
          const SizedBox(height: 16),
          _CampaignLink(
            label: "20% de desconto",
            route: "/lp03",
          ),
        ],
      ),
    );
  }
}

class _CampaignLink extends StatelessWidget {
  const _CampaignLink({
    required this.label,
    required this.route,
  });

  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return _HoverableLink(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Icon(Icons.arrow_forward, color: Color(0xFF686868)),
          ],
        ),
      ),
    );
  }
}

class _HoverableLink extends StatefulWidget {
  const _HoverableLink({
    required this.child,
    required this.onTap,
  });

  final Widget child;
  final VoidCallback onTap;

  @override
  State<_HoverableLink> createState() => _HoverableLinkState();
}

class _HoverableLinkState extends State<_HoverableLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: _hovered ? 0.9 : 1,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
