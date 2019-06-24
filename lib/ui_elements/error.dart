import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fast_noise/fast_noise.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Error extends StatefulWidget {
  final double pixelSize;
  final double pixelBlockRatio;
  final Color color;

  Error({
    this.color = Colors.white,
    this.pixelSize = 18,
    this.pixelBlockRatio = 1.4,
  });

  @override
  _ErrorState createState() => _ErrorState();
}

class _ErrorState extends State<Error> with SingleTickerProviderStateMixin {
  PerlinNoise _perlinNoise;

  AnimationController _controller;
  int loops = 0;

  @override
  void initState() {
    super.initState();
    _perlinNoise = PerlinNoise(
      octaves: 4,
      frequency: 0.25,
      seed: math.Random().nextInt(1337),
    );
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _controller.addStatusListener(_loopAnimation);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _loopAnimation(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _controller.forward(from: 0.0);
      loops++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget child) {
              double off = _controller.value + loops;
              return CustomPaint(
                painter: NoisePainter(
                  noise: _perlinNoise,
                  off: off,
                  color: widget.color,
                  pixelBlockRatio: widget.pixelBlockRatio,
                  pixelSize: widget.pixelSize,
                ),
              );
            },
          ),
          Center(
            child: Container(
              color: Theme.of(context).canvasColor,
              height: 200.0,
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 22.0,
                vertical: 8.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  AutoSizeText(
                    "Shower thoughts are down",
                    style: Theme.of(context).textTheme.headline,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                  AutoSizeText(
                    "Check your internet",
                    style: Theme.of(context).textTheme.subhead,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NoisePainter extends CustomPainter {
  final double pixelSize;
  final double blockSize;
  final Color color;
  final PerlinNoise noise;
  final double off;

  static const max = 0.5;
  static const min = -max;

  NoisePainter({
    @required this.noise,
    @required this.off,
    @required this.color,
    @required this.pixelSize,
    @required double pixelBlockRatio,
  }) : this.blockSize = pixelSize * pixelBlockRatio;

  @override
  void paint(Canvas canvas, Size size) {
    final double minBeforeBlack = 100;
    Paint paint = Paint()..style = PaintingStyle.fill;
    for (double i = 0; i < size.width / blockSize; i++) {
      for (double j = 0; j < size.height / blockSize; j++) {
        final double x = i * blockSize;
        final double y = j * blockSize;
        double val = noise.getPerlin3(i, j, off);
        val = (val - min) / (max - min);
        val = val * 255;
        if (val < minBeforeBlack) {
          val = lerpDouble(-200, minBeforeBlack, val / 100);
        }
        val = math.min(val, 255);
        val = math.max(val, 0);

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
