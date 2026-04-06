import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:solarstriker/game/enemy.dart';
import 'package:solarstriker/game/game.dart';

class Rocket extends SpriteAnimationComponent
    with HasGameRef<SolarStrikerGame>, HasHitboxes, Collidable  {
  final double _animationSpeed = 0.125;

  Rocket({ required Vector2 position })
      : super(position: position, size: Vector2(16, 16)) {
    //
  }

  @override
  void onMount() {
    super.onMount();

    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: gameRef.images.fromCache('laser-bolts.png'),
      rows: 2,
      columns: 2,
    );
    animation = spriteSheet.createAnimation(row: 1, stepTime: _animationSpeed);

    final shape = HitboxCircle(normalizedRadius: 0.8);
    addHitbox(shape);
  }

  @override
  void update(double dt) {
    super.update(dt);

    position -= Vector2(0, 150 * dt);

    if(position.y < 0) {
      remove(this);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is Enemy) {
      gameRef.remove(this);
    }
    super.onCollision(intersectionPoints, other);
  }
}