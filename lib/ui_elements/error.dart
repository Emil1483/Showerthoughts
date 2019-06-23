import 'dart:math';

import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width,
      child: CustomPaint(
        painter: NoisePainter(),
      ),
    );
  }
}

class NoisePainter extends CustomPainter {
  final double pixelSize;
  final double blockSize;
  final Color color;

  NoisePainter({
    this.color = Colors.white,
    this.pixelSize = 18,
    double pixelBlockRatio = 1.4,
  }) : this.blockSize = pixelSize * pixelBlockRatio;

  @override
  void paint(Canvas canvas, Size size) {
    final Random random = Random();
    Paint paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < size.width / blockSize; i++) {
      for (int j = 0; j < size.height / blockSize; j++) {
        final double x = i * blockSize;
        final double y = j * blockSize;
        canvas.drawRect(
          Rect.fromLTWH(x, y, pixelSize, pixelSize),
          paint..color = color.withAlpha(random.nextInt(255)),
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
