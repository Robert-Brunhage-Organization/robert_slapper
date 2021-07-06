import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';
import 'package:robert_slapper/components/lines/spawn_line.dart';
import 'package:robert_slapper/main.dart';

import 'ball_line.dart';
import 'despawner.dart';

class BallLineSpawner {
  BallLineSpawner({
    required this.game,
  });

  final RobertSlapper game;
  late SpawnLine _spawnLine;

  Despawner createDespawner() {
    final despawner = Despawner(
      shape: Rectangle(size: Vector2(20, 200)),
      shapePaint: Paint()..color = Colors.transparent,
      y: game.size.y,
      x: 0,
      game: game,
    );
    return despawner;
  }

  SpawnLine createBallLineSpawner(VoidCallback onSpawn) {
    _spawnLine = SpawnLine(
        shape: Rectangle(size: Vector2(20, 200)),
        shapePaint: Paint()..color = Colors.transparent,
        game: game,
        onSpawn: () {
          onSpawn();
        });
    return _spawnLine;
  }

  BallLine createBallLine() {
    Random rnd = Random();
    final randomWidth = rnd.nextInt(100) + 50;
    final platform = BallLine(
      shape: RoundedRectangle(radius: 8, size: Vector2(randomWidth.toDouble(), 20)),
      shapePaint: Paint()..color = Colors.blue,
      game: game,
      x: game.canvasSize.x + 100,
      y: game.canvasSize.y - 50,
    );
    return platform;
  }
}
