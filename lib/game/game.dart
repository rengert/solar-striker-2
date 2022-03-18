import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:solarstriker/game/enemy.dart';
import 'package:solarstriker/game/rocket.dart';
import 'package:solarstriker/game/ship.dart';

import 'explosion.dart';

class SolarStrikerGame extends FlameGame
    with HasCollidables {
  Ship? _ship;
  double _sinceLastEnemy = 0;
  int _playerScore = 0;
  int _level = 1;
  int _lifes = 3;

  late TextComponent _playerScoreText;
  late TextComponent _levelText;
  late TextComponent _lifesText;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    await _loadStuff();
    await _addBackground();
    _loadScreen();
    _addShip();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _sinceLastEnemy += dt;
    if(_sinceLastEnemy > 5 - (_level / 10)) {
      _sinceLastEnemy = 0;

      _spawnEnemy();
    }
  }

  void move(Offset delta) {
    _ship?.move(delta);
  }

  void fire() {
    _ship?.setAutoFire();
  }

  void stopFire() {
    // _ship?.stopAutoFire();
  }

  void explode(Vector2 vector) {
    var explosion = Explosion(
        position: vector,
    );
    add(explosion);
  }

  Future<void> _loadStuff() async {
    await images.loadAll([
      'desert-background-looped.png',
      'ship.png',
      'explosion.png',
      'laser-bolts.png',
      'enemy-big.png'
    ]);
  }

  void _addShip() {
    _ship = Ship(
        position: Vector2(canvasSize.x / 2, canvasSize.y - 150),
        maxPosition: canvasSize,
        onFire: _shipFired
    );
    add(_ship!);
  }

  void _spawnEnemy() {
    var random = Random();
    var speed = 15 + _level;
    var enemy = Enemy(
      image: images.fromCache('enemy-big.png'),
      size: Vector2(32, 32),
      position: Vector2(random.nextDouble() * canvasSize.x, 0),
      speed: speed
    );
    add(enemy);
  }

  Future<void> _addBackground() async {
    ParallaxComponent _background = await ParallaxComponent.load(
      [
        ParallaxImageData('desert-background-looped.png'),
      ],
      fill:  LayerFill.width,
      repeat: ImageRepeat.repeat,
      baseVelocity: Vector2(0, -50),
      velocityMultiplierDelta: Vector2(0, 1.5),
    );
    add(_background);
  }

  void _shipFired(Vector2 position) {
    var rocket = Rocket(
        position: Vector2(_ship!.x + 8, _ship!.y - 20),
    );
    add(rocket);
  }

  void _loadScreen() {
    // Create text component for player score.
    _playerScoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(10, 50),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'BungeeInline',
        ),
      ),
    );
    add(_playerScoreText);

    _levelText = TextComponent(
      text: 'Level: 1',
      position: Vector2(canvasSize.x - 20, 50),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'BungeeInline',
        ),
      ),
    );
    _levelText.anchor = Anchor.topRight;
    add(_levelText);

    _lifesText = TextComponent(
      text: 'Leben: 1',
      position: Vector2(canvasSize.x - 20, 70),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'BungeeInline',
        ),
      ),
    );
    _lifesText.anchor = Anchor.topRight;
    add(_lifesText);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);

    _ship?.position = Vector2(canvasSize.x / 2, canvasSize.y - 100);
  }

  void killed() {
    _playerScore++;
    _level = (_playerScore / 25).ceil();
    _updateScreen();
  }

  void shipHit() {
    _lifes--;
    _updateScreen();
    if(_lifes <= 0) {
      pauseEngine();
    }
  }

  void reset() {
    _level = 1;
    _lifes = 3;
    _playerScore = 0;
    _sinceLastEnemy = 0;

    children.forEach((element) {
      if(element is Enemy || element is Rocket) {
        element.removeFromParent();
      }
    });
    _updateScreen();
  }

  void _updateScreen() {
    _lifesText.text = "Leben: " + _lifes.toStringAsFixed(0);
    _playerScoreText.text = 'Score: ' + _playerScore.toStringAsFixed(0);
    _levelText.text = 'Level: ' + _level.toStringAsFixed(0);
  }
}