import 'package:flutter/material.dart';
import 'dart:math';

class WaveClipper extends CustomClipper<Path> {
  final double waveValue;

  WaveClipper(this.waveValue);

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height * 0.8);

    for (double i = 0.0; i <= size.width; i++) {
      path.lineTo(
        i,
        size.height * 0.8 + sin(i / size.width * 2 * pi + waveValue) * 20,
      );
    }

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => true;
}
