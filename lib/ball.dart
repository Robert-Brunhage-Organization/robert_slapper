import 'dart:ui';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import 'lines/ball_line.dart';
import 'robert_slapper.dart';

class Ball extends SpriteComponent with Hitbox, Collidable {
  Ball({
    required this.game,
  }) {
    //debugMode = true;
    addShape(HitboxCircle(definition: 0.8));
  }

  final RobertSlapper game;

  bool isColliding = false;
  bool isOffScreen = false;
  List<Collidable> currentlyColliding = [];

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('Logo.png');
    size = Vector2.all(128.0);
    this.anchor = Anchor.center;
    return super.onLoad();
  }

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
        game.sessionManager.updateScore();
        collisionParticle(Colors.blue);
        FlameAudio.play('impact.mp3', volume: 0.4);
        other.remove();
      }
      if (other is ScreenCollidable) {
        isOffScreen = true;
        collisionParticle(Colors.red);
        game.sessionManager.reduceHealth();
      }
    }
  }

  void collisionParticle(Color color) {
    math.Random rnd = math.Random();
    Vector2 randomVector2() => (Vector2.random(rnd) - Vector2.random(rnd)) * 800;
    game.add(
      ParticleComponent(
        particle: Particle.generate(
          count: 40,
          lifespan: 1,
          generator: (i) {
            return AcceleratedParticle(
              acceleration: randomVector2(),
              speed: randomVector2(),
              position: (this.position.clone() + Vector2(0, this.size.y / 1.5)),
              child: ComputedParticle(
                renderer: (canvas, particle) => canvas.drawCircle(
                  Offset.zero,
                  particle.progress * 10,
                  Paint()
                    ..color = Color.lerp(
                      color,
                      color.withAlpha(0),
                      particle.progress,
                    )!,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void onCollisionEnd(Collidable other) {
    currentlyColliding.remove(other);
  }
}
