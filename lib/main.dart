import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robert_slapper/components/lines/ball_line.dart';
import 'package:robert_slapper/components/lines/ball_line_spawner.dart';
import 'package:robert_slapper/components/session_manager.dart';

import 'components/ball.dart';

class RobertSlapper extends BaseGame with TapDetector, HasCollidables {
  bool hasTapped = false;
  late Ball ball;

  late final SessionManager sessionManager;
  late final BallLineSpawner ballLineSpawner;

  final List<BallLine> lines = List.empty(growable: true);

  @override
  Future<void> onLoad() {
    FlameAudio.bgm.initialize();
    //viewport = FixedResolutionViewport(Vector2(700, 600));
    camera.shakeIntensity = 20;
    ball = Ball(
      game: this,
    );
    sessionManager = SessionManager(game: this, size: size);
    ballLineSpawner = BallLineSpawner(game: this);

    add(sessionManager);
    add(ScreenCollidable());
    add(ball);
    final spawnLine = ballLineSpawner.createBallLineSpawner(() {
      final subsequentPlatform = ballLineSpawner.createBallLine();
      lines.add(subsequentPlatform);
      add(subsequentPlatform);
    });
    final despawner = ballLineSpawner.createDespawner();
    add(despawner);
    add(spawnLine);
    return super.onLoad();
  }

  void start() {
    resumeEngine();
    removeAll(lines);
    lines.clear();

    final initialPlatform = ballLineSpawner.createBallLine();
    add(initialPlatform);
    lines.add(initialPlatform);
    FlameAudio.bgm.play('Automation.mp3', volume: 0.2);
  }

  @override
  void onDetach() {
    FlameAudio.bgm.dispose();
    super.onDetach();
  }

  @override
  void onTap() {
    ball.isOffScreen = false;
    ball.isColliding = false;
    hasTapped = true;
    super.onTap();
  }

  @override
  void update(double dt) {
    //print("isOffscreen: ${ball.isOffScreen}, hasTapped: ${hasTapped}, isColliding: ${ball.isColliding}");
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    // Player Controls
    if (hasTapped) {
      ball.position.moveToTarget(Vector2(canvasSize.x / 2, canvasSize.y + 60), 20);
      if (ball.isColliding || ball.isOffScreen) {
        hasTapped = false;
      }
    } else {
      ball.position.moveToTarget(canvasSize / 2, 20);
    }
    super.render(canvas);
  }

  @override
  Color backgroundColor() {
    return Colors.grey.shade800;
  }
}

const pauseMenu = 'PauseMenu';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final robertSlapper = RobertSlapper();
  await Flame.device.setOrientation(DeviceOrientation.landscapeLeft);
  await Flame.device.fullScreen();
  runApp(
    GameWidget<RobertSlapper>(
      game: robertSlapper,
      initialActiveOverlays: [
        pauseMenu,
      ],
      overlayBuilderMap: {
        'PauseMenu': (contaxt, game) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Robert Slapper',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                      )),
                  Spacer(),
                  Image.asset(
                    'assets/images/Logo.png',
                    height: 180,
                  ),
                  Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      primary: Colors.black,
                    ),
                    onPressed: () {
                      robertSlapper.overlays.remove(pauseMenu);
                      robertSlapper.start();
                    },
                    child: Text('Start Game'),
                  )
                ],
              ),
            ),
          );
        },
      },
    ),
  );
}
