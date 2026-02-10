import 'package:flutter/material.dart';
import 'package:frontend/views/public/public_scaffold.dart';
import 'package:frontend/widgets/hero_section.dart';
import 'package:frontend/widgets/benefits_section.dart';
import 'package:frontend/widgets/authority_section.dart';

class Lp02View extends StatelessWidget {
  const Lp02View({super.key});

  @override
  Widget build(BuildContext context) {
    return PublicScaffold(
      applyContentPadding: false,
      scrollHeader: true,
      body: Column(
        children: const [
          HeroSection(
            title: "Ganhe seu\nprojeto com\narquiteto -\nsem custo",
            subtitle:
                "Planejamento profissional incluso ao\nfechar seus móveis.",
            formTitle: "Receba seu projeto exclusivo",
            formSubtitle:
                "Planejamento profissional incluso\npara transformar seu ambiente.",
            formHighlight: "Sem compromisso.\nVocê só avança se amar o projeto.",
            buttonText: "Quero meu projeto",
            source: "lp02",
            backgroundAsset: "assets/images/img_lps/lp02/lp02_img_herosection.png",
          ),
          BenefitsSection(),
          AuthoritySection(
            backgroundAsset: "assets/images/img_lps/lp02/lp02_img_autoridade.png",
          ),
        ],
      ),
    );
  }
}
