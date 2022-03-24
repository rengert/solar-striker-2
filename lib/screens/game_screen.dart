import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:solarstriker/game/game.dart';
import '../interaction/joypad.dart';
import '../models/direction.dart';
import '../overlays/pause.dart';
import '../overlays/pause_menu.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  late SolarStrikerGame game;

  @override
  Widget build(BuildContext context) {
    game = SolarStrikerGame(context);
    return Scaffold(
        backgroundColor: const Color.fromRGBO(125, 125, 255, 1),
        body: Stack(
          children: [
            GameWidget(
                game: game,
                initialActiveOverlays: const [PauseButton.ID],
                overlayBuilderMap: {
                  PauseButton.ID: (BuildContext context, SolarStrikerGame gameRef) =>
                      PauseButton(
                        gameRef: gameRef,
                      ),
                  PauseMenu.ID: (BuildContext context, SolarStrikerGame gameRef) =>
                      PauseMenu(
                        gameRef: gameRef,
                      ),
                },
              ),
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
