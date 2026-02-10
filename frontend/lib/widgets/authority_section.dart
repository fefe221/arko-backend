import 'package:flutter/material.dart';

class AuthoritySection extends StatelessWidget {
  const AuthoritySection({super.key, this.backgroundAsset});

  final String? backgroundAsset;
  static const _textPrimary = Color(0xFF686868);

  Widget _customButton(String text) {
    return SizedBox(
      width: 240,
      height: 40,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.45),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: "Birken Nue",
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    Widget left = Column(
      children: [
        _customButton("Projetos"),
        const SizedBox(height: 16),
        _customButton("Contato"),
      ],
    );

    Widget right = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E6DE).withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mais que móveis\nplanejados",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Cada projeto é executado com rigor técnico,\nacabamento premium e um compromisso\nreal com a experiência do cliente.",
            style: TextStyle(color: _textPrimary),
          ),
          SizedBox(height: 16),
          Text(
            "Ao longo dos anos, transformamos ambientes em espaços\nfuncionais, sofisticados e feitos para durar.\n"
            "Nosso processo combina planejamento técnico,\n"
            "design inteligente e execução de alto padrão — \n"
            "garantindo que cada detalhe seja pensado para refletir\n"
            "qualidade, conforto e exclusividade. Não entregamos apenas móveis.\n"
            "Entregamos ambientes que elevam a experiência de viver.",
            style: TextStyle(color: _textPrimary),
          ),
        ],
      ),
    );

    final horizontalPadding = isMobile ? 20.0 : 150.0;
    final verticalPadding = isMobile ? 40.0 : 60.0;
    final content = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: isMobile
          ? Column(children: [left, const SizedBox(height: 32), right])
          : Row(
              children: [
                Expanded(child: left),
                const SizedBox(width: 40),
                Expanded(child: right),
              ],
            ),
    );

    if (backgroundAsset == null) {
      return content;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundAsset!),
          fit: BoxFit.cover,
        ),
      ),
      child: content,
    );
  }
}
