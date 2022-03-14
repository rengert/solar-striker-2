import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:solarstriker/game/game.dart';

class Explosion extends SpriteAnimationComponent with HasGameRef<SolarStrikerGame> {
  final double _animationSpeed = 0.125;

  Explosion({
    required Image image,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size) {
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      rows: 1,
      columns: 5,
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, loop: false);
    animation!.onComplete = _end;
    anchor = Anchor.center;
   }

   void _end() {
    gameRef.remove(this);
  }
}