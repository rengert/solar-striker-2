import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/foundation.dart';
import 'package:solarstriker/game/enemy.dart';
import 'package:solarstriker/game/power_up.dart';

import '../models/shot.dart';
import 'game.dart';

class Ship extends SpriteAnimationComponent
    with HasGameRef<SolarStrikerGame>, HasHitboxes, Collidable {
  final ValueChanged<Shot> onFire;

  final double _animationSpeed = 0.125;
  late SpriteAnimation _moveMuchLeft;
  late SpriteAnimation _moveLeft;
  late SpriteAnimation _moveStraight;
  late SpriteAnimation _moveRight;
  late SpriteAnimation _moveMuchRight;
  late Vector2 _maxPosition = Vector2.zero();

  double _fireSpeed = 1;
  double _firePower = 1;
  bool _autoFire = false;
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
      if(_sinceLastShot > _fireSpeed) {
        _sinceLastShot = 0;
        _fire(_firePower);
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

  void _fire(double power) {
    onFire(Shot(power, position));
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

  void powerUp(PowerUpType type) {
    switch(type) {
      case PowerUpType.power:
        _firePower = min(3, _firePower + 1);
        break;
      case PowerUpType.speed:
        _fireSpeed = _fireSpeed * 0.95;
        break;
    }
  }

  void reset() {
    _fireSpeed = 1;
    _firePower = 1;
  }
}