import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';

import '../robert_slapper.dart';
import 'ball_line.dart';
import 'despawner.dart';
import 'spawn_line.dart';

class BallLineManager {
  BallLineManager({
    required this.game,
  });

  final RobertSlapper game;
  late SpawnLine _spawnLine;

  final List<BallLine> lines = List.empty(growable: true);

  void addDespawner() {
    final despawner = Despawner(
      shape: Rectangle(size: Vector2(20, 200)),
      shapePaint: Paint()..color = Colors.transparent,
      y: game.size.y,
      x: 0,
      game: game,
    );
    game.add(despawner);
  }

  void addBallLineSpawner() {
    _spawnLine = SpawnLine(
        shape: Rectangle(size: Vector2(20, 200)),
        shapePaint: Paint()..color = Colors.transparent,
        game: game,
        onSpawn: () {
          final subsequentPlatform = createBallLine();
          lines.add(subsequentPlatform);
          game.add(subsequentPlatform);
        });
    game.add(_spawnLine);
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

  void reset() {
    game.components.removeAll(lines);
    lines.clear();
  }
}
