import 'package:flutter/material.dart';

class GradientPlaceholder extends StatelessWidget {
  const GradientPlaceholder({
    super.key,
    required this.seed,
    this.borderRadius = 16,
  });

  final int seed;
  final double borderRadius;

  Color _color(int salt) {
    final hue = ((seed + salt) % 360).toDouble();
    return HSVColor.fromAHSV(1, hue, 0.55, 0.38).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_color(0), _color(80), _color(160)],
        ),
      ),
    );
  }
}
