import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:solarstriker/game/game.dart';
import 'package:solarstriker/game/rocket.dart';

enum EnemyType {
  small,
  medium,
  big
}

class Enemy extends SpriteAnimationComponent
    with HasGameRef<SolarStrikerGame>, HasHitboxes, Collidable {

  final double _animationSpeed = 0.125;
  late int _speed = 25;
  late EnemyType _type = EnemyType.small;

  Enemy({
    required EnemyType type,
    required Vector2 position,
    required Vector2 size,
    required int speed,
  }) : super(position: position, size: size) {
    anchor = Anchor.center;
    _type = type;
    _speed = speed;
  }

  @override
  void onMount() {
    super.onMount();

    var imageName = 'enemy-big.png';
    switch(_type) {
      case EnemyType.small:
        imageName = 'enemy-small.png';
        size = Vector2(16, 16);
        break;
      case EnemyType.medium:
        imageName = 'enemy-medium.png';
        size = Vector2(32, 16);
        break;
      case EnemyType.big:
        imageName = 'enemy-big.png';
        size = Vector2(32, 32);
        break;
    }

    var image = gameRef.images.fromCache(imageName);
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      rows: 1,
      columns: 2,
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed);

    final shape = HitboxCircle(normalizedRadius: 0.8);
    addHitbox(shape);
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += Vector2(0, _speed * dt);

    if(position.y > 2000) {
      position = Vector2(position.x, 0);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is Rocket) {
      hit();
      gameRef.killed(position);
    }
    super.onCollision(intersectionPoints, other);
  }

  void hit() {
    gameRef.explode(position);
    gameRef.remove(this);
  }
}