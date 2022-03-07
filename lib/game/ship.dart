import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:solarstriker/models/direction.dart';

class Ship extends SpriteAnimationComponent {
  late SpriteAnimation _moveMuchLeft;
  late SpriteAnimation _moveLeft;
  late SpriteAnimation _moveStraight;
  late SpriteAnimation _moveRight;
  late SpriteAnimation _moveMuchRight;

  Ship({
    required Image image,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size) {
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      rows: 5,
      columns: 2,
    );

    _moveMuchLeft = spriteSheet.createAnimation(row: 0, stepTime: 0.125);
    _moveLeft = spriteSheet.createAnimation(row: 1, stepTime: 0.125);
    _moveStraight = spriteSheet.createAnimation(row: 2, stepTime: 0.125);
    _moveRight = spriteSheet.createAnimation(row: 3, stepTime: 0.125);
    _moveMuchRight = spriteSheet.createAnimation(row: 4, stepTime: 0.125);

    animation = _moveStraight;
  }

  void move(Direction direction) {
    switch(direction) {
      case Direction.none:
        animation = _moveStraight;
        break;
      case Direction.up:
        // TODO: Handle this case.
        break;
      case Direction.down:
        // TODO: Handle this case.
        break;
      case Direction.left:
        animation = _moveMuchLeft;
        break;
      case Direction.right:
        animation = _moveMuchRight;
        break;
    }
  }
}