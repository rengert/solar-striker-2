import 'package:flutter/material.dart';
import 'package:solarstriker/overlays/pause.dart';
import 'package:solarstriker/screens/main_menu.dart';

import '../../game/game.dart';

class DeadMenu extends StatelessWidget {
  static const String ID = 'DeadMenu';
  final SolarStrikerGame gameRef;

  const DeadMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pause menu title.
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 25.0),
            child: Text(
              'Kampf ist vorbei',
              style: TextStyle(
                fontSize: 45.0,
                color: Colors.black,
                shadows: [
                  Shadow(
                    blurRadius: 40.0,
                    color: Colors.white,
                    offset: Offset(0, 0),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: Text(
              'Punkte: '   + gameRef.playerScore.toStringAsFixed(0),
              style: const TextStyle(
                fontSize: 45.0,
                color: Colors.black,
                shadows: [
                  Shadow(
                    blurRadius: 40.0,
                    color: Colors.white,
                    offset: Offset(0, 0),
                  )
                ],
              ),
            ),
          ),

          // Restart button.
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                gameRef.overlays.remove(DeadMenu.ID);
                gameRef.overlays.add(PauseButton.ID);
                gameRef.reset();
                gameRef.resumeEngine();
              },
              child: const Text('Neustart'),
            ),
          ),

          // Exit button.
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                gameRef.overlays.remove(DeadMenu.ID);
                gameRef.reset();

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const MainMenu(),
                  ),
                );
              },
              child: const Text('Kampf abbrechen'),
            ),
          ),
        ],
      ),
    );
  }
}