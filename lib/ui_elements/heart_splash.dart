import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HeartSplash extends StatefulWidget {
  final Widget child;
  final Curve curve;
  final Color color;

  HeartSplash({
    @required this.child,
    this.color = Colors.white,
    this.curve = Curves.linear,
  }) : assert(child != null);

  static HeartSplashState of(BuildContext context) {
    assert(context != null);
    final HeartSplashState result =
        context.ancestorStateOfType(const TypeMatcher<HeartSplashState>());
    if (result != null) return result;
    throw FlutterError(
        "HeartSplashState.of() called with a context that does not contain an HeartSplash");
  }

  @override
  HeartSplashState createState() => HeartSplashState();
}

class HeartSplashState extends State<HeartSplash>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  _HeartPainter __heartPainter;

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    __heartPainter = _HeartPainter(
      _controller,
      color: widget.color,
      curve: widget.curve,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void animate({Offset pos = const Offset(100, 100)}) {
    _controller.reset();
    _controller.animateTo(
      1,
      duration: Duration(milliseconds: 800),
    );
    __heartPainter.heartPos = pos;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: __heartPainter,
      child: widget.child,
    );
  }
}

class _HeartPainter extends CustomPainter {
  final AnimationController _controller;

  final Curve curve;
  final Color color;

  Offset _heartPos = Offset(0, 0);

  _HeartPainter(
    this._controller, {
    this.curve,
    this.color,
  }) : super(repaint: _controller);

  set heartPos(Offset pos) {
    _heartPos = pos;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_controller.isDismissed) return;
    canvas.translate(_heartPos.dx, _heartPos.dy);

    final double heartSize = math.max(size.width, size.height);
    final double value = curve.transform(_controller.value);
    _heart(
      canvas: canvas,
      scale: heartSize,
      value: value,
    );
  }

  @override
  bool shouldRepaint(_HeartPainter oldDelegate) => true;

  void _heart({Canvas canvas, double scale, double value}) {
    final int alpha = ((1 - math.sqrt(value)) * 255).toInt().clamp(0, 255);
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color.withAlpha(alpha);

    final double size = scale * value / 16;
    final int res = 100;

    Path path = Path();
    for (int i = 0; i < res; i++) {
      final double t = i.toDouble() * math.pi * 2 / res;
      double x = 16 * math.pow(math.sin(t), 3);
      double y = -13 * math.cos(t) +
          5 * math.cos(2 * t) +
          2 * math.cos(3 * t) +
          math.cos(4 * t);
      if (i == 0)
        path.moveTo(x * size, y * size);
      else
        path.lineTo(x * size, y * size);
    }
    canvas.drawPath(path, paint);
  }
}
