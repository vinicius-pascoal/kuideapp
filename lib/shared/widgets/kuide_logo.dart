import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Marca visual única do KUIDE, reutilizada nas áreas públicas e autenticadas.
class KuideLogo extends StatelessWidget {
  const KuideLogo({
    super.key,
    this.size = 40,
    this.framed = false,
    this.semanticLabel = 'Logo KUIDE',
  });

  final double size;
  final bool framed;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    // O SVG recebido é uma imagem PNG embutida em um pattern, formato que o
    // flutter_svg não renderiza de forma confiável. Usamos a extração local
    // da própria marca para garantir a exibição em todas as plataformas.
    final logo = Image.asset(
      'assets/images/kuide_logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      semanticLabel: semanticLabel,
    );

    if (!framed) return logo;

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * .07),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(size * .22),
      ),
      child: logo,
    );
  }
}
