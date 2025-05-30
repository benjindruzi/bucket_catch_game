import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Ball extends CircleComponent {
  static const double ballSpeed = 200.0;

  Ball() : super(
    radius: 15,
  );

  @override
  void update(double dt) {
    super.update(dt);
    position.y += ballSpeed * dt;
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(radius, radius);
    final gradient = RadialGradient(
      colors: [
        Colors.lightBlue[300]!,
        Colors.blue[600]!,
      ],
      stops: [0.3, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    canvas.drawCircle(center, radius, paint);

    final highlightPaint = Paint()..color = Colors.white.withOpacity(0.3);
    canvas.drawCircle(
      Offset(radius - 5, radius - 5),
      radius * 0.3,
      highlightPaint,
    );
  }
}