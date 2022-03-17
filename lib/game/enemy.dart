import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:solarstriker/game/game.dart';
import 'package:solarstriker/game/rocket.dart';

class Enemy extends SpriteAnimationComponent
    with HasGameRef<SolarStrikerGame>, HasHitboxes, Collidable {

  final double _animationSpeed = 0.125;
  late int _speed = 15;

  Enemy({
    required Image image,
    required Vector2 position,
    required Vector2 size,
    required int speed,
  }) : super(position: position, size: size) {
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      rows: 1,
      columns: 2,
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed);
    anchor = Anchor.center;
    _speed = speed;
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

    position += Vector2(0, _speed * dt);

    if(position.y > 2000) {
      remove(this);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is Rocket) {
      hit();
      gameRef.killed();
    }
    super.onCollision(intersectionPoints, other);
  }

  void hit() {
    gameRef.explode(position);
    gameRef.remove(this);
  }
}