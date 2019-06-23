import 'dart:ui';
import 'dart:ui' as prefix0;

import 'package:flutter/material.dart';

class LoadingRect extends StatefulWidget {
  final Color mainColor;
  final Color secColor;
  final double gap;

  LoadingRect(
      {this.mainColor = Colors.black,
      this.secColor = Colors.white,
      this.gap = 0.1});
  @override
  _LoadingRectState createState() => _LoadingRectState();
}

class _LoadingRectState extends State<LoadingRect>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: LoadingPainter(
          gap: widget.gap,
          mainColor: widget.mainColor,
          secColor: widget.secColor,
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}

class LoadingPainter extends CustomPainter {
  final Color mainColor;
  final Color secColor;
  final double gap;

  LoadingPainter({
    this.mainColor,
    this.secColor,
    this.gap,
  });
  @override
  void paint(Canvas canvas, Size size) {
    double preOff = 0.4;
    double off = preOff * (gap * 2 + 1);
    Paint painting = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.orange
      ..shader = prefix0.Gradient.linear(
        Offset(0, 0),
        Offset(size.width, size.height),
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
    return true;
  }
}
