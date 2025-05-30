import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'components/bucket.dart';
import 'components/ball.dart';

class BucketCatchGame extends FlameGame with PanDetector {
  late Bucket bucket;
  late Timer ballSpawnTimer;

  final ValueNotifier<int> scoreNotifier = ValueNotifier(0);
  final ValueNotifier<int> livesNotifier = ValueNotifier(3);

  final Function(int) onGameOver;

  double ballSpawnInterval = 1.5;
  final double minSpawnInterval = 0.3;

  int _score = 0;
  int _lives = 3;

  Random random = Random();
  List<Ball> balls = [];

  BucketCatchGame({required this.onGameOver});

  @override
  Future<void> onLoad() async {
    // Add background
    add(RectangleComponent(
      size: size,
      paint: Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.lightBlue[300]!,
            Colors.lightBlue[50]!,
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.x, size.y)),
    ));

    _addClouds();

    // Create bucket
    bucket = Bucket();
    bucket.position = Vector2(size.x / 2 - bucket.size.x / 2, size.y - 120);
    add(bucket);

    // Setup ball spawning timer
    ballSpawnTimer = Timer(
      ballSpawnInterval,
      repeat: true,
      onTick: _spawnBall,
    );
    ballSpawnTimer.start();
  }

  void _addClouds() {
    for (int i = 0; i < 5; i++) {
      add(CloudComponent(
        position: Vector2(
          random.nextDouble() * size.x,
          random.nextDouble() * size.y * 0.3,
        ),
      ));
    }
  }

  void _spawnBall() {
    final ball = Ball();
    ball.position = Vector2(
      random.nextDouble() * (size.x - ball.size.x),
      -ball.size.y,
    );
    add(ball);
    balls.add(ball);
  }

  @override
  void update(double dt) {
    super.update(dt);
    ballSpawnTimer.update(dt);

    final ballsToRemove = <Ball>[];

    for (final ball in List.from(balls)) {
      // Check if ball fell off screen
      if (ball.position.y > size.y) {
        ballsToRemove.add(ball);
        _loseLife();
        continue;
      }

      // Manual collision detection with bucket
      if (_checkCollision(ball, bucket)) {
        ballsToRemove.add(ball);
        catchBall(ball);
      }
    }

    // Remove balls
    for (final ball in ballsToRemove) {
      ball.removeFromParent();
      balls.remove(ball);
    }
  }

  bool _checkCollision(Ball ball, Bucket bucket) {
    // Get ball center
    final ballCenterX = ball.position.x + ball.radius;
    final ballCenterY = ball.position.y + ball.radius;

    // Get bucket collision area
    final bucketLeft = bucket.position.x + 10;
    final bucketRight = bucket.position.x + bucket.size.x - 10;
    final bucketTop = bucket.position.y + 5;
    final bucketBottom = bucket.position.y + 25; // Only the top part counts

    // Check if ball center is inside bucket opening
    final isInside = ballCenterX >= bucketLeft &&
        ballCenterX <= bucketRight &&
        ballCenterY >= bucketTop &&
        ballCenterY <= bucketBottom;

    if (isInside) {
      print("COLLISION DETECTED!");
    }

    return isInside;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    bucket.position.x = info.eventPosition.global.x - bucket.size.x / 2;
    bucket.position.x = bucket.position.x.clamp(0, size.x - bucket.size.x);
  }

  void catchBall(Ball ball) {
    _score++;
    scoreNotifier.value = _score;
    print("Ball caught! Score: $_score");

    // Increase difficulty every 5 points
    if (_score % 5 == 0) {
      ballSpawnInterval = (ballSpawnInterval * 0.9).clamp(minSpawnInterval, 2.0);
      ballSpawnTimer.stop();
      ballSpawnTimer = Timer(
        ballSpawnInterval,
        repeat: true,
        onTick: _spawnBall,
      );
      ballSpawnTimer.start();
    }
  }

  void _loseLife() {
    _lives--;
    livesNotifier.value = _lives;
    print("Life lost! Lives remaining: $_lives");

    if (_lives <= 0) {
      onGameOver(_score);
    }
  }

  void reset() {
    _score = 0;
    _lives = 3;
    scoreNotifier.value = _score;
    livesNotifier.value = _lives;
    ballSpawnInterval = 1.5;

    // Remove all balls
    for (final ball in List.from(balls)) {
      ball.removeFromParent();
    }
    balls.clear();

    // Reset timer
    ballSpawnTimer.stop();
    ballSpawnTimer = Timer(
      ballSpawnInterval,
      repeat: true,
      onTick: _spawnBall,
    );
    ballSpawnTimer.start();

    // Reset bucket position
    bucket.position = Vector2(size.x / 2 - bucket.size.x / 2, size.y - 120);
  }
}

class CloudComponent extends RectangleComponent {
  CloudComponent({required Vector2 position})
      : super(
    position: position,
    size: Vector2(60, 30),
    paint: Paint()..color = Colors.white.withOpacity(0.8),
  );

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.white.withOpacity(0.8);

    canvas.drawCircle(Offset(15, 15), 15, paint);
    canvas.drawCircle(Offset(35, 15), 12, paint);
    canvas.drawCircle(Offset(45, 15), 10, paint);
    canvas.drawCircle(Offset(25, 8), 13, paint);
  }
}