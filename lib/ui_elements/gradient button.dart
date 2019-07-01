import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final Function onPressed;
  final Widget child;
  final Gradient gradient;

  GradientButton({
    @required this.onPressed,
    @required this.child,
    @required this.gradient,
  })  : assert(child != null),
        assert(gradient != null);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32.0),
      child: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            highlightColor: Theme.of(context).indicatorColor,
            onTap: onPressed,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 22.0),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
