import 'dart:math' as math;

import 'package:flutter/material.dart';

class Transitioner extends StatelessWidget {
  final Animation animation;
  final Widget child1;
  final Widget child2;
  final Curve curve;

  final double toMin;
  final double toMax;
  final double fromMin;
  final double fromMax;

  Transitioner({
    @required this.animation,
    @required this.child1,
    @required this.child2,
    this.curve = Curves.easeInOutCubic,
    this.toMin = 0,
    this.toMax = 1,
    this.fromMin = 0,
    this.fromMax = 1,
  })  : assert(animation != null),
        assert(child1 != null),
        assert(child2 != null);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        double value = animation.value - fromMin;
        value *= (toMax - toMin) / (fromMax - fromMin);
        value += toMin;
        value = math.max(0, value);
        value = math.min(1, value);
        value = curve.transform(value);
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..scale(math.cos(value * math.pi * 2) * 0.5 + 0.5),
          child: value <= 0.5 ? child1 : child2,
        );
      },
    );
  }
}
