import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:solarstriker/game/game.dart';
import 'package:solarstriker/game/ship.dart';

enum PowerUpType {
  speed,
  power,
}

class PowerUp extends SpriteAnimationComponent
    with HasGameRef<SolarStrikerGame>, HasHitboxes, Collidable {

  PowerUpType type;
  final double _animationSpeed = 0.125;
  final int _speed = 5;

  PowerUp({
    required Vector2 position,
    required this.type,
  }) : super(position: position, size: Vector2(16, 16)) {
    anchor = Anchor.center;
  }

  @override
  void onMount() {
    super.onMount();

    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: gameRef.images.fromCache('power-up.png'),
      rows: 2,
      columns: 2,
    );
    animation = spriteSheet.createAnimation(row: type.index, stepTime: _animationSpeed);

    final shape = HitboxCircle(normalizedRadius: 0.8);
    addHitbox(shape);
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += Vector2(0, _speed * dt);

    if(position.y > 2000) {
      remove(this);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is Ship) {
      other.powerUp(type);
      hit();
    }
    super.onCollision(intersectionPoints, other);
  }

  void hit() {
    gameRef.remove(this);
  }
}