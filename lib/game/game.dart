import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:solarstriker/game/rocket.dart';
import 'package:solarstriker/game/ship.dart';
import 'package:solarstriker/models/direction.dart';

class SolarStrikerGame extends FlameGame {
  late Ship _ship;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'desert-background-looped.png',
      'ship.png'
    ]);

    await _addBackground();

    _ship = Ship(
      image: await images.load('ship.png'),
      size: Vector2(32, 32),
      position: Vector2(canvasSize.x / 2, canvasSize.y - 150),
      maxPosition: canvasSize,
      onFire: _shipFired
    );
    add(_ship);
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

  void move(Offset delta) {
    _ship.move(delta);
  }

  void fire() {
    _ship.setAutoFire();
  }

  void stopFire() {
    _ship.stopAutoFire();
  }

  void _shipFired(Vector2 position) {
    var rocket = Rocket(
        image: images.fromCache('ship.png'),
        size: Vector2(32, 32),
        position: Vector2(_ship.x, _ship.y - 20),
    );
    add(rocket);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);

    _ship.position = Vector2(canvasSize.x / 2, canvasSize.y - 100);
  }
}