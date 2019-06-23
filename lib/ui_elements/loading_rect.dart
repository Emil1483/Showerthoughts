import 'dart:math' as math;
import 'dart:ui';
import 'dart:ui' as prefix0;

import 'package:flutter/material.dart';

class LoadingRect extends StatefulWidget {
  final Color mainColor;
  final Color secColor;
  final double gap;
  final Duration animDuration;

  LoadingRect({
    this.mainColor = Colors.black,
    this.secColor = Colors.white,
    this.gap = 0.1,
    this.animDuration = const Duration(seconds: 1),
  });
  @override
  _LoadingRectState createState() => _LoadingRectState();
}

class _LoadingRectState extends State<LoadingRect>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animDuration,
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
    } else if (status == AnimationStatus.dismissed) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget child) {
          return CustomPaint(
            painter: LoadingPainter(
              animOff: _controller.value,
              gap: widget.gap,
              mainColor: widget.mainColor,
              secColor: widget.secColor,
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
            ),
          );
        },
      ),
    );
  }
}

class LoadingPainter extends CustomPainter {
  final double animOff;
  final Color mainColor;
  final Color secColor;
  final double gap;

  LoadingPainter({
    @required this.animOff,
    this.mainColor,
    this.secColor,
    this.gap,
  }) : assert(animOff != null);
  @override
  void paint(Canvas canvas, Size size) {
    final double off = animOff * (gap * 2 + 1);
    final double len = math.max(size.height, size.width);
    Paint painting = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.orange
      ..shader = prefix0.Gradient.linear(
        Offset(0, 0),
        Offset(len, len),
        [mainColor, secColor, mainColor],
        [off - gap * 2, off - gap, off],
      );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      painting,
    );
  }

  @override
  bool shouldRepaint(LoadingPainter oldDelegate) {
    return animOff != oldDelegate.animOff;
  }
}
