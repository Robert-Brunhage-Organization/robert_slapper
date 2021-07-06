import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/gestures.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:robert_slapper/components/ball_line_spawner.dart';
import 'package:robert_slapper/components/session_manager.dart';

import 'components/ball.dart';

class RobertSlapper extends BaseGame with TapDetector, HasCollidables {
  bool hasTapped = false;
  late Ball ball;

  late final SessionManager scoreManager;
  late final BallLineSpawner platformSpawner;

  @override
  Future<void> onLoad() {
    camera.shakeIntensity = 20;
    scoreManager = SessionManager(size: size);
    platformSpawner = BallLineSpawner(game: this);
    ball = Ball(
      shape: Circle(radius: 28),
      shapePaint: Paint()..color = Colors.red,
      game: this,
    );

    final initialPlatform = platformSpawner.createBallLine();
    final spawnLine = platformSpawner.spawnBallLineSpawner(() {
      final subsequentPlatform = platformSpawner.createBallLine();
      add(subsequentPlatform);
    });

    add(scoreManager);
    add(scoreManager.score);
    add(scoreManager.healthLeft);

    add(ScreenCollidable());
    add(ball);
    add(spawnLine);
    add(initialPlatform);

    return super.onLoad();
  }

  @override
  void onTap() {
    ball.isOffScreen = false;
    ball.isColliding = false;
    hasTapped = true;
    super.onTap();
  }

  @override
  void update(double dt) {
    //print("isOffscreen: ${ball.isOffScreen}, hasTapped: ${hasTapped}, isColliding: ${ball.isColliding}");
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    // Player Controls
    if (hasTapped) {
      ball.position.moveToTarget(Vector2(canvasSize.x / 2, canvasSize.y + 60), 20);
      if (ball.isColliding || ball.isOffScreen) {
        hasTapped = false;
      }
    } else {
      ball.position.moveToTarget(canvasSize / 2, 20);
    }
    super.render(canvas);
  }

  @override
  Color backgroundColor() {
    return Colors.grey.shade800;
  }
}

void main() {
  final robertSlapper = RobertSlapper();
  runApp(
    GameWidget(
      game: robertSlapper,
    ),
  );
}
