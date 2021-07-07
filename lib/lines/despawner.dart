import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/painting.dart';

import '../../robert_slapper.dart';
import 'ball_line.dart';

class Despawner extends ShapeComponent with Hitbox, Collidable {
  Despawner({
    required Shape shape,
    required Paint shapePaint,
    required double x,
    required double y,
    required this.game,
  }) : super(shape, shapePaint) {
    // debugMode = true;
    addShape(HitboxRectangle());
  }

  final RobertSlapper game;

  @override
  void onGameResize(Vector2 gameSize) {
    position = Vector2(0, game.canvasSize.y - height / 2);
    super.onGameResize(gameSize);
  }

  @override
  void onCollisionEnd(Collidable other) {
    if (other is BallLine) {
      game.sessionManager.reduceHealth();
      other.remove();
    }
    super.onCollisionEnd(other);
  }
}
