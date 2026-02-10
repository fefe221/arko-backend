import 'package:flutter/material.dart';
import 'package:frontend/views/public/public_scaffold.dart';
import 'package:frontend/widgets/hero_section.dart';
import 'package:frontend/widgets/benefits_section.dart';
import 'package:frontend/widgets/authority_section.dart';

class Lp01View extends StatelessWidget {
  const Lp01View({super.key});

  @override
  Widget build(BuildContext context) {
    return PublicScaffold(
      applyContentPadding: false,
      scrollHeader: true,
      body: Column(
        children: const [
          HeroSection(
            title: "Seu projeto\nentregue no \nprazo.\n- com garantia\npremium",
            subtitle:
                "Planejados de alto padrão com\ncompromisso real\nde qualidade e entrega!",
            formTitle: "Solicite atendimento premium prioritário",
            formSubtitle:
                "Seu projeto com garantia estendida\ne compromisso de entrega",
            buttonText: "Atendimento Prioritário",
            source: "lp01",
            backgroundAsset: "assets/images/img_lps/lp01/img_lp01.png",
          ),
          BenefitsSection(),
          AuthoritySection(
            backgroundAsset:
                "assets/images/img_lps/lp01/background_section_autoridade.png",
          ),
        ],
      ),
    );
  }
}
