import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';
import 'package:solarstriker/game/enemy.dart';
import 'package:solarstriker/game/rocket.dart';
import 'package:solarstriker/game/ship.dart';

class SolarStrikerGame extends FlameGame
    with HasCollidables {
  Ship? _ship;

  double _sinceLastEnemy = 0;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    await _loadStuff();
    await _addBackground();
    _addShip();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _sinceLastEnemy += dt;
    if(_sinceLastEnemy > 5) {
      _sinceLastEnemy = 0;

      var enemy = Enemy(
        image: images.fromCache('laser-bolts.png'),
        size: Vector2(64, 64),
        position: Vector2(_ship!.x + 8, _ship!.y - 500),
      );
      add(enemy);
    }
  }

  void move(Offset delta) {
    _ship?.move(delta);
  }

  void fire() {
    _ship?.setAutoFire();
  }

  void stopFire() {
    _ship?.stopAutoFire();
  }

  Future<void> _loadStuff() async {
    await images.loadAll([
      'desert-background-looped.png',
      'ship.png',
      'laser-bolts.png'
    ]);
  }

  void _addShip() {
    _ship = Ship(
        image: images.fromCache('ship.png'),
        size: Vector2(32, 32),
        position: Vector2(canvasSize.x / 2, canvasSize.y - 150),
        maxPosition: canvasSize,
        onFire: _shipFired
    );
    add(_ship!);
  }

  Future<void> _addBackground() async {
    ParallaxComponent _background = await ParallaxComponent.load(
      [
        ParallaxImageData('desert-background-looped.png'),
      ],
      fill:  LayerFill.width,
      repeat: ImageRepeat.repeat,
      baseVelocity: Vector2(0, -50),
      velocityMultiplierDelta: Vector2(0, 1.5),
    );
    add(_background);
  }

  void _shipFired(Vector2 position) {
    var rocket = Rocket(
        image: images.fromCache('laser-bolts.png'),
        size: Vector2(16, 16),
        position: Vector2(_ship!.x + 8, _ship!.y - 20),
    );
    add(rocket);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);

    _ship?.position = Vector2(canvasSize.x / 2, canvasSize.y - 100);
  }
}