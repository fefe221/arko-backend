import 'package:flutter/material.dart';

class BenefitsSection extends StatelessWidget {
  const BenefitsSection({super.key});

  Widget card(String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFE8E6DE),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 28, color: Color(0xFF686868)),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(desc),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 900;
    int columns = width > 1200
        ? 4
        : width > 900
            ? 2
            : 1;

    final items = [
      card(
        "Garantia Estendida",
        "Garantia Estendida: Segurança e tranquilidade para o seu investimento. "
            "Oferecemos uma cobertura ampliada que vai além do padrão de mercado, "
            "assegurando a durabilidade e a integridade de cada detalhe do seu "
            "projeto de alto padrão por muito mais tempo.",
      ),
      card(
        "Prazo Protegido",
        "Prazo Protegido: Respeito absoluto ao seu cronograma. Garantimos a "
            "entrega e montagem rigorosamente na data combinada, com políticas "
            "de transparência e compromisso, para que você planeje sua mudança "
            "ou renovação sem nenhum imprevisto.",
      ),
      card(
        "Instalação Premium",
        "Instalação Premium: Cuidado artesanal na fase final. Nossa equipe "
            "técnica especializada utiliza equipamentos de ponta e protocolos "
            "de limpeza rigorosos, garantindo um ajuste perfeito, proteção total "
            "do seu ambiente e um acabamento impecável.",
      ),
      card(
        "Revisão Pós-entrega",
        "Revisão Pós-entrega: O compromisso com a perfeição não termina na "
            "montagem. Realizamos uma visita técnica programada após a entrega "
            "para ajustes finos de ferragens e verificação de cada detalhe, "
            "assegurando que sua experiência de uso seja sempre excelente.",
      ),
    ];

    final horizontalPadding = isMobile ? 20.0 : 150.0;
    final verticalPadding = isMobile ? 40.0 : 60.0;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        decoration: BoxDecoration(
          color: const Color(0xFF3B3B3B),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            const Text(
              "Compromisso Arkō",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth;
                final spacing = 20.0;
                final effectiveColumns = isMobile ? 1 : columns;
                final itemWidth = (maxWidth -
                        spacing * (effectiveColumns - 1)) /
                    effectiveColumns;
                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: items
                      .map(
                        (item) => SizedBox(
                          width: itemWidth,
                          child: item,
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
