// lib/features/game/presentation/widgets/hex_clipper.dart

import 'package:flutter/material.dart';

// Esta classe define a forma de hexágono que será usada para recortar nosso widget.
// É a tradução direta da propriedade `clip-path` do seu CSS.
class HexClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Move o cursor para o ponto inicial (topo central)
    path.moveTo(size.width * 0.50, 0);
    // Desenha as linhas para os outros 5 pontos do hexágono
    path.lineTo(size.width * 0.93, size.height * 0.25);
    path.lineTo(size.width * 0.93, size.height * 0.75);
    path.lineTo(size.width * 0.50, size.height * 1.00);
    path.lineTo(size.width * 0.07, size.height * 0.75);
    path.lineTo(size.width * 0.07, size.height * 0.25);
    // Fecha o caminho, conectando o último ponto ao primeiro
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
