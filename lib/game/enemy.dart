import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:solarstriker/game/game.dart';
import 'package:solarstriker/game/rocket.dart';

class Enemy extends SpriteAnimationComponent
    with HasGameRef<SolarStrikerGame>, HasHitboxes, Collidable {

  final double _animationSpeed = 0.125;

  Enemy({
    required Image image,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size) {
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      rows: 2,
      columns: 2,
    );
    animation = spriteSheet.createAnimation(row: 1, stepTime: _animationSpeed);
   }

  @override
  void onMount() {
    super.onMount();

    final shape = HitboxCircle(normalizedRadius: 0.8);
    addHitbox(shape);
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += Vector2(0, 20 * dt);

    if(position.y > 2000) {
      remove(this);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is Rocket) {
      gameRef.remove(this);
    }
    super.onCollision(intersectionPoints, other);
  }
}