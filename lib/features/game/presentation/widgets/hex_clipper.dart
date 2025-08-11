import 'package:flutter/material.dart';

class HexClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.50, 0);
    path.lineTo(size.width * 0.93, size.height * 0.25);
    path.lineTo(size.width * 0.93, size.height * 0.75);
    path.lineTo(size.width * 0.50, size.height * 1.00);
    path.lineTo(size.width * 0.07, size.height * 0.75);
    path.lineTo(size.width * 0.07, size.height * 0.25);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
