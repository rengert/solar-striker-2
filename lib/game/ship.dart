import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/foundation.dart';
import 'package:solarstriker/game/enemy.dart';

import 'game.dart';

class Ship extends SpriteAnimationComponent
    with HasGameRef<SolarStrikerGame>, HasHitboxes, Collidable {
  final ValueChanged<Vector2> onFire;

  final double _animationSpeed = 0.125;
  bool _autoFire = false;
  late SpriteAnimation _moveMuchLeft;
  late SpriteAnimation _moveLeft;
  late SpriteAnimation _moveStraight;
  late SpriteAnimation _moveRight;
  late SpriteAnimation _moveMuchRight;
  late Vector2 _maxPosition = Vector2.zero();

  Vector2 _moveDirection = Vector2.zero();

  double _sinceLastShot = 0;

  Ship({
    required Vector2 position,
    required Vector2 maxPosition,
    required this.onFire,
  }) : super(position: position, size: Vector2(32, 32)) {
    _maxPosition = maxPosition;
  }


  @override
  void update(double dt) {
    super.update(dt);

    position += _moveDirection * 5 * dt;
    position.clamp(Vector2.zero() - size / 2, _maxPosition - size / 2);

    _sinceLastShot += dt;
    if(_autoFire) {
      if(_sinceLastShot > .175) {
        _sinceLastShot = 0;
        _fire();
      }
    }
  }

  @override
  void onMount() {
    super.onMount();

    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: gameRef.images.fromCache('ship.png'),
      rows: 5,
      columns: 2,
    );

    _moveMuchLeft = spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed);
    _moveLeft = spriteSheet.createAnimation(row: 1, stepTime: _animationSpeed);
    _moveStraight = spriteSheet.createAnimation(row: 2, stepTime: _animationSpeed);
    _moveRight = spriteSheet.createAnimation(row: 3, stepTime: _animationSpeed);
    _moveMuchRight = spriteSheet.createAnimation(row: 4, stepTime: _animationSpeed);

    animation = _moveStraight;

    final shape = HitboxCircle(normalizedRadius: 0.8);
    addHitbox(shape);
  }

  void move(Offset delta) {
    _moveDirection = Vector2(delta.dx, 0);
    _setDirection(delta);
  }


  void setAutoFire() {
    _autoFire = true;
  }

  void stopAutoFire() {
    _autoFire = false;
  }

  void _fire() {
    onFire(position);
  }

  void _setDirection(Offset offset) {
    if (offset.dx > 20) {
      animation = _moveMuchRight;
    } else if (offset.dx > 5) {
      animation = _moveRight;
    } else if (offset.dx < -20) {
      animation = _moveMuchLeft;
    } else if (offset.dx < -5) {
      animation = _moveLeft;
    } else {
      animation = _moveStraight;
    }
  }


  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is Enemy) {
      gameRef.explode(position);
      gameRef.shipHit();
      other.hit();
    }
    super.onCollision(intersectionPoints, other);
  }
}