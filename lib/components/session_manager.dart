import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:robert_slapper/main.dart';

class SessionManager extends BaseComponent {
  SessionManager({required this.game, required Vector2 size}) {
    TextPaint regular = TextPaint(config: TextPaintConfig(color: Colors.white));
    score = TextComponent('score: $_score', textRenderer: regular)
      ..anchor = Anchor.topCenter
      ..x = size.x / 1.7 // size is a property from game
      ..y = 32.0
      ..isHud = true;

    healthLeft = TextComponent('health: $_healthLeft', textRenderer: regular)
      ..anchor = Anchor.topCenter
      ..x = size.x / 2.5 // size is a property from game
      ..y = 32.0
      ..isHud = true;
  }

  final RobertSlapper game;

  int _score = 0;
  late TextComponent score;

  int _healthLeft = 3;
  late TextComponent healthLeft;

  @override
  Future<void>? onLoad() {
    addChild(score);
    addChild(healthLeft);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    healthLeft.x = gameSize.x / 2.5;
    score.x = gameSize.x / 1.7; // size is a property from game
    super.onGameResize(gameSize);
  }

  @override
  void update(double dt) {
    score.text = 'score: $_score';
    healthLeft.text = 'health: $_healthLeft';

    if (_healthLeft <= 0) {
      game.overlays.add(pauseMenu);
      game.pauseEngine();
      reset();
    }
    super.update(dt);
  }

  void reset() {
    _score = 0;
    _healthLeft = 3;
  }

  void updateScore() {
    _score++;
  }

  void reduceHealth() {
    _healthLeft--;
    FlameAudio.play('ouch.mp3', volume: 0.2);
  }
}
