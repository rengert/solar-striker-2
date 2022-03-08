import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:solarstriker/game/ship.dart';
import 'package:solarstriker/models/direction.dart';

class SolarStrikerGame extends FlameGame {
  late Ship _ship;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'desert-background-looped.png'
    ]);

    await _addBackground();

    _ship = Ship(
      image: await images.load('ship.png'),
      size: Vector2(32, 32),
      position: canvasSize / 2,
      maxPosition: canvasSize,
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
}