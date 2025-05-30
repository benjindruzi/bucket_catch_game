import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Bucket extends RectangleComponent {
  Bucket() : super(
    size: Vector2(80, 60),
  );

  @override
  void render(Canvas canvas) {
    // bucket shape
    final paint = Paint()..color = Colors.brown[600]!;
    final handlePaint = Paint()..color = Colors.brown[800]!;

    // bucket body
    final path = Path();
    path.moveTo(10, 15); // Top left
    path.lineTo(size.x - 10, 15); // Top right
    path.lineTo(size.x - 5, size.y); // Bottom right
    path.lineTo(5, size.y); // Bottom left
    path.close();

    canvas.drawPath(path, paint);

    // handles
    canvas.drawRect(Rect.fromLTWH(0, 20, 8, 15), handlePaint);
    canvas.drawRect(Rect.fromLTWH(size.x - 8, 20, 8, 15), handlePaint);

    // rim
    canvas.drawRect(Rect.fromLTWH(8, 12, size.x - 16, 6), handlePaint);
  }
}