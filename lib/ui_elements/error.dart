import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fast_noise/fast_noise.dart';

class Error extends StatefulWidget {
  @override
  _ErrorState createState() => _ErrorState();
}

class _ErrorState extends State<Error> with SingleTickerProviderStateMixin {
  PerlinNoise _perlinNoise;

  @override
  void initState() {
    super.initState();
    _perlinNoise = PerlinNoise(octaves: 4, frequency: 0.15, seed: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width,
      child: CustomPaint(
        painter: NoisePainter(noise: _perlinNoise),
      ),
    );
  }
}

class NoisePainter extends CustomPainter {
  final double pixelSize;
  final double blockSize;
  final Color color;
  final PerlinNoise noise;

  static const max = sqrt1_2;
  static const min = -max;

  NoisePainter({
    @required this.noise,
    this.color = Colors.white,
    this.pixelSize = 18,
    double pixelBlockRatio = 1.4,
  }) : this.blockSize = pixelSize * pixelBlockRatio;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..style = PaintingStyle.fill;
    for (double i = 0; i < size.width / blockSize; i++) {
      for (double j = 0; j < size.height / blockSize; j++) {
        final double x = i * blockSize;
        final double y = j * blockSize;
        double val = noise.getPerlin2(i, j);
        val = (val - min) / (max - min);
        val = val * 255;
        print(val);

        canvas.drawRect(
          Rect.fromLTWH(x, y, pixelSize, pixelSize),
          paint..color = color.withAlpha(val.round()),
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
