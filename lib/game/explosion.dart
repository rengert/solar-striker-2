import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:solarstriker/game/game.dart';

class Explosion extends SpriteAnimationComponent with HasGameRef<SolarStrikerGame> {
  final double _animationSpeed = 0.125;

  Explosion({
    required Vector2 position,
  }) : super(position: position, size: Vector2(16, 16)) {
    anchor = Anchor.center;
   }

   @override
  void onMount() {
    super.onMount();

    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: gameRef.images.fromCache('explosion.png'),
      rows: 1,
      columns: 5,
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, loop: false);
    animation!.onComplete = _end;
  }

   void _end() {
    gameRef.remove(this);
  }
}