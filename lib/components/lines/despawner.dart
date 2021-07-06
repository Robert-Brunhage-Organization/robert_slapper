import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/painting.dart';
import 'package:robert_slapper/main.dart';

class Despawner extends ShapeComponent with Hitbox, Collidable {
  Despawner({
    required Shape shape,
    required Paint shapePaint,
    required double x,
    required double y,
    required this.game,
  }) : super(shape, shapePaint) {
    position = Vector2(game.canvasSize.x - 100, game.canvasSize.y - 100);
    // debugMode = true;
    addShape(HitboxRectangle());
  }

  final RobertSlapper game;

  @override
  void onGameResize(Vector2 gameSize) {
    position = Vector2(0, game.canvasSize.y - height / 2);
    super.onGameResize(gameSize);
  }
}
