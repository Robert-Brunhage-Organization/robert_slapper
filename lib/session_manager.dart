import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

import 'robert_slapper.dart';

class SessionManager extends BaseComponent {
  SessionManager({required this.game, required Vector2 size}) {
    TextPaint regular = TextPaint(config: TextPaintConfig(color: Colors.white));
    scoreComponent = TextComponent(
      'score: $_score',
      textRenderer: regular,
    )
      ..anchor = Anchor.topCenter
      ..y = 10.0;

    highScoreComponent = TextComponent(
      'highScore: $_highScore',
      textRenderer: regular,
    )
      ..anchor = Anchor.topRight
      ..y = 10.0;

    healthLeftComponent = TextComponent(
      'health: $_healthLeft',
      textRenderer: regular,
    )
      ..anchor = Anchor.topLeft
      ..y = 10.0;
    isHud = true;
  }

  final RobertSlapper game;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  int _score = 0;
  int get score => _score;
  late TextComponent scoreComponent;

  int _highScore = 0;
  late TextComponent highScoreComponent;

  int _healthLeft = 3;
  int get healthLeft => _healthLeft;
  late TextComponent healthLeftComponent;

  bool _playing = false;
  bool get playing => _playing;

  @override
  Future<void>? onLoad() {
    _prefs.then((prefs) {
      _highScore = prefs.getInt('highScore') ?? 0;
    });
    addChild(scoreComponent);
    addChild(highScoreComponent);
    addChild(healthLeftComponent);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    healthLeftComponent.x = gameSize.x / 6;
    highScoreComponent.x = 5 * gameSize.x / 6;
    scoreComponent.x = gameSize.x / 2; // size is a property from game
    super.onGameResize(gameSize);
  }

  @override
  void update(double dt) {
    scoreComponent.text = 'score: $_score';
    healthLeftComponent.text = 'health: $_healthLeft';
    if (_highScore < _score) {
      _highScore = _score;
    }
    highScoreComponent.text = 'highScore: $_highScore';

    if (_healthLeft <= 0) {
      if (_score >= _highScore) {
        _prefs.then((prefs) {
          prefs.setInt('highScore', _score);
        });
      }
      _playing = false;
      game.overlays.add(pauseMenu);
      game.pauseEngine();
    }
    super.update(dt);
  }

  void reset() {
    _score = 0;
    _healthLeft = 3;
    _playing = true;
  }

  void updateScore() {
    _score++;
  }

  void reduceHealth() {
    _healthLeft--;
    if (_healthLeft > 0) {
      final particle = createRedScreenParticle();
      game.add(particle);
      FlameAudio.play('ouch.mp3', volume: 0.2);
    }
  }

  ParticleComponent createRedScreenParticle() {
    final particle = ParticleComponent(
      particle: ComputedParticle(
        lifespan: 0.3,
        renderer: (canvas, particle) {
          final rectangle = Rect.fromCenter(
            center: Offset(game.size.x / 2, game.size.y / 2),
            width: game.size.x * 2,
            height: game.size.y * 2,
          );
          canvas.drawRect(
            rectangle,
            Paint()
              ..color = Colors.red
              ..style = PaintingStyle.fill
              ..shader = RadialGradient(colors: [
                Colors.transparent,
                Colors.red,
              ]).createShader(rectangle)
              ..strokeWidth = 2,
          );
        },
      ),
    );

    return particle;
  }
}
