import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:solarstriker/game/ship.dart';

class SolarStrikerGame extends FlameGame {
  late Ship _ship;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'desert-background-looped.png'
    ]);

    await _addBackground();

    var spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: images.fromCache('simpleSpace_tilesheet@2.png'),
      columns: 8,
      rows: 6,
    );

    _ship = Ship(
      sprite: spriteSheet.getSpriteById(spaceship.spriteId),
      size: Vector2(64, 64),
      position: canvasSize / 2,
    );
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
}