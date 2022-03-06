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
  @override
  Widget build(BuildContext context) {
    var game = SolarStrikerGame();
    return Scaffold(
        backgroundColor: const Color.fromRGBO(125, 125, 255, 1),
        body: Stack(
          children: [
            GameWidget(game: game),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Joypad(onDirectionChanged: onJoypadDirectionChanged),
              ),
            )
          ],
        ));
  }

  void onJoypadDirectionChanged(Direction direction) {
    // TODO 2
  }
}
