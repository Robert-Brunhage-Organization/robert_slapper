import 'dart:ui';

import 'package:flame/geometry.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:robert_slapper/main.dart';

import 'ball_line.dart';

class BallLineSpawner {
  BallLineSpawner({
    required this.game,
  });

  final RobertSlapper game;
  SpawnLine? _spawnLine;

  spawnBallLineSpawner(VoidCallback onSpawn) {
    _spawnLine = SpawnLine(
        shape: Rectangle(size: Vector2(20, 200)),
        shapePaint: Paint()..color = Colors.purple,
        game: game,
        onSpawn: () {
          onSpawn();
        });
    return _spawnLine;
  }

  BallLine createBallLine() {
    final platform = BallLine(
      shape: Rectangle(size: Vector2(100, 20)),
      shapePaint: Paint()..color = Colors.blue,
      game: game,
      x: game.canvasSize.x + 100,
      y: game.canvasSize.y - 50,
    );
    return platform;
  }
}
