import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:solarstriker/game/game.dart';
import 'interaction/joypad.dart';
import 'models/direction.dart';

class MainGamePage extends StatefulWidget {
  const MainGamePage({Key? key}) : super(key: key);

  @override
  MainGameState createState() => MainGameState();
}

class MainGameState extends State<MainGamePage> {
  var game = SolarStrikerGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(125, 125, 255, 1),
        body: Stack(
          children: [
            GameWidget(game: game),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Joypad(
                  onDirectionChanged: onJoypadDirectionChanged,
                  onDeltaChanged: onJoypadDeltaChanged,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0x88ffffff),
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      onPanDown: startFire,
                      onPanEnd: stopFire,
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  void onJoypadDirectionChanged(Direction direction) {
    // game.move(direction);
  }

  void onJoypadDeltaChanged(Offset delta) {
    game.move(delta);
  }

  void startFire(DragDownDetails details) {
    game.fire();
  }
  void stopFire(DragEndDetails details) {
    game.stopFire();
  }
}
