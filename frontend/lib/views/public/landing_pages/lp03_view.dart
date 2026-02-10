import 'package:flutter/material.dart';
import 'package:frontend/views/public/public_scaffold.dart';
import 'package:frontend/widgets/hero_section.dart';
import 'package:frontend/widgets/benefits_section.dart';
import 'package:frontend/widgets/authority_section.dart';

class Lp03View extends StatelessWidget {
  const Lp03View({super.key});

  @override
  Widget build(BuildContext context) {
    return PublicScaffold(
      applyContentPadding: false,
      scrollHeader: true,
      body: Column(
        children: const [
          HeroSection(
            title:
                "Realize seus móveis\nplanejados\ncom 20%\nde vantagem\nexclusiva",
            subtitle:
                "Design premium, acabamento impecável\ne condições especiais por tempo limitado.",
            formTitle: "Garanta seus 20% de vantagem agora",
            formSubtitle:
                "Receba seu orçamento\npersonalizado com condição\nexclusiva por tempo limitado.",
            buttonText: "Quero meu desconto",
            source: "lp03",
            backgroundAsset: "assets/images/img_lps/lp03/lp03_img_herosection.png",
          ),
          BenefitsSection(),
          AuthoritySection(
            backgroundAsset: "assets/images/img_lps/lp03/lp03_img.png",
          ),
        ],
      ),
    );
  }
}
