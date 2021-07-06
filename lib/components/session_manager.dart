import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class SessionManager extends Component {
  SessionManager({required Vector2 size}) {
    TextPaint regular = TextPaint(config: TextPaintConfig(color: Colors.white));
    score = TextComponent('score: $_score', textRenderer: regular)
      ..anchor = Anchor.topCenter
      ..x = size.x / 2 // size is a property from game
      ..y = 32.0
      ..isHud = true;

    healthLeft = TextComponent('health: $_healthLeft', textRenderer: regular)
      ..anchor = Anchor.topCenter
      ..x = size.x / 3 // size is a property from game
      ..y = 32.0
      ..isHud = true;
  }

  int _score = 0;
  late TextComponent score;

  int _healthLeft = 3;
  late TextComponent healthLeft;

  @override
  void update(double dt) {
    score.text = 'score: $_score';
    healthLeft.text = 'health: $_healthLeft';
    super.update(dt);
  }

  void updateScore() {
    _score++;
  }

  void reduceHealth() {
    _healthLeft--;
  }
}
