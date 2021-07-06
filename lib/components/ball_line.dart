import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/painting.dart';
import 'package:robert_slapper/main.dart';

class BallLine extends ShapeComponent with Hitbox, Collidable {
  BallLine({
    required Shape shape,
    required Paint shapePaint,
    required this.game,
    required double x,
    required double y,
  }) : super(shape, shapePaint) {
    position = Vector2(x, y);
    debugMode = true;
    addShape(HitboxRectangle());
  }

  final RobertSlapper game;
  bool isOffScreen = false;

  @override
  void update(double dt) {
    position.x -= 1;
    if (shape.position.x < 0) {
      isOffScreen = true;
    } else {
      isOffScreen = false;
    }
    super.update(dt);
  }
}

class SpawnLine extends ShapeComponent with Hitbox, Collidable {
  SpawnLine({
    required Shape shape,
    required Paint shapePaint,
    required this.game,
    required this.onSpawn,
  }) : super(shape, shapePaint) {
    position = Vector2(game.canvasSize.x - 100, game.canvasSize.y - 100);
    debugMode = true;
    addShape(HitboxRectangle());
  }

  final RobertSlapper game;
  final VoidCallback onSpawn;

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    position = Vector2(game.canvasSize.x - 100, game.canvasSize.y - 100);
    super.onGameResize(gameSize);
  }

  @override
  void onCollisionEnd(Collidable other) {
    if (other is BallLine) {
      onSpawn();
    }
    super.onCollisionEnd(other);
  }
}
