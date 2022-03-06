import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';

class SolarStrikerGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'desert-background-looped.png'
    ]);

    await _addBackground();
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