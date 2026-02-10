import 'package:flutter/material.dart';

class LpBenefitsSection extends StatelessWidget {
  const LpBenefitsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF3C3C3C),
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 900;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Compromisso Arkō",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 28),
              GridView.count(
                crossAxisCount: isMobile ? 1 : 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                childAspectRatio: isMobile ? 1.6 : 2.3,
                children: const [
                  _BenefitCard(
                    title: "Garantia Estendida",
                    body:
                        "Garantia Estendida: Segurança e tranquilidade para o seu "
                        "investimento. Oferecemos uma cobertura ampliada que vai "
                        "além do padrão de mercado, assegurando a durabilidade e a "
                        "integridade de cada detalhe do seu projeto de alto padrão "
                        "por muito mais tempo.",
                  ),
                  _BenefitCard(
                    title: "Prazo Protegido",
                    body:
                        "Prazo Protegido: Respeito absoluto ao seu cronograma. "
                        "Garantimos a entrega e montagem rigorosamente na data "
                        "combinada, com políticas de transparência e compromisso, "
                        "para que você planeje sua mudança ou renovação sem nenhum "
                        "imprevisto.",
                  ),
                  _BenefitCard(
                    title: "Instalação Premium",
                    body:
                        "Instalação Premium: Cuidado artesanal na fase final. Nossa "
                        "equipe técnica especializada utiliza equipamentos de ponta "
                        "e protocolos de limpeza rigorosos, garantindo um ajuste "
                        "perfeito, proteção total do seu ambiente e um acabamento "
                        "impecável.",
                  ),
                  _BenefitCard(
                    title: "Revisão Pós-entrega",
                    body:
                        "Revisão Pós-entrega: O compromisso com a perfeição não "
                        "termina na montagem. Realizamos uma visita técnica "
                        "programada após a entrega para ajustes finos de ferragens "
                        "e verificação de cada detalhe, assegurando que sua "
                        "experiência de uso seja sempre excelente.",
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class LpAuthoritySection extends StatelessWidget {
  const LpAuthoritySection({super.key, required this.background});

  final String background;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(background),
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 900;
          return Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: isMobile ? double.infinity : 560,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: const Color(0xFFE8E6DE).withOpacity(0.75),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Mais que móveis\nplanejados",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF686868),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Cada projeto é executado com rigor técnico,\n"
                    "acabamento premium e um compromisso\n"
                    "real com a experiência do cliente.",
                    style: TextStyle(color: Color(0xFF8A8A8A)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Ao longo dos anos, transformamos ambientes em espaços\n"
                    "funcionais, sofisticados e feitos para durar.\n"
                    "Nosso processo combina planejamento técnico,\n"
                    "design inteligente e execução de alto padrão —\n"
                    "garantindo que cada detalhe seja pensado para refletir\n"
                    "qualidade, conforto e exclusividade. Não entregamos apenas móveis.\n"
                    "Entregamos ambientes que elevam a experiência de viver.",
                    style: TextStyle(color: Color(0xFF8A8A8A)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class LpPill extends StatelessWidget {
  const LpPill({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white70),
      ),
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E6DE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Text(body, style: const TextStyle(color: Color(0xFF8A8A8A))),
        ],
      ),
    );
  }
}
