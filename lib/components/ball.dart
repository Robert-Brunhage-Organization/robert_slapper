import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:robert_slapper/components/ball_line.dart';
import 'package:robert_slapper/main.dart';

class Ball extends ShapeComponent with Hitbox, Collidable {
  Ball({
    required Shape shape,
    required Paint shapePaint,
    required this.game,
  }) : super(shape, shapePaint) {
    debugMode = true;
    addShape(HitboxCircle());
  }

  final RobertSlapper game;

  bool isColliding = false;
  bool isOffScreen = false;
  List<Collidable> currentlyColliding = [];

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    // We don't need to set the position in the constructor, we can it directly here since it will
    // be called once before the first time it is rendered.
    position = gameSize / 2;
    super.onGameResize(gameSize);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
    if (!currentlyColliding.contains(other)) {
      currentlyColliding.add(other);
      if (other is BallLine) {
        isColliding = true;
        game.camera.shake();
        game.scoreManager.updateScore();
        other.remove();
      }
      if (other is ScreenCollidable) {
        isOffScreen = true;
        game.scoreManager.reduceHealth();
      }
    }
  }

  void onCollisionEnd(Collidable other) {
    currentlyColliding.remove(other);
  }
}
