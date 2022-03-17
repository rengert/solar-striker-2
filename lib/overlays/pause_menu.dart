import 'package:flutter/material.dart';
import 'package:solarstriker/overlays/pause.dart';

import '../../game/game.dart';

class PauseMenu extends StatelessWidget {
  static const String ID = 'PauseMenu';
  final SolarStrikerGame gameRef;

  const PauseMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pause menu title.
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            child: Text(
              'Kampf pausiert',
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

          // Resume button.
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                gameRef.resumeEngine();
                gameRef.overlays.remove(PauseMenu.ID);
                gameRef.overlays.add(PauseButton.ID);
              },
              child: const Text('Weiter gehts'),
            ),
          ),

          // Restart button.
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                gameRef.overlays.remove(PauseMenu.ID);
                gameRef.overlays.add(PauseButton.ID);
                //gameRef.reset();
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
                gameRef.overlays.remove(PauseMenu.ID);
                //gameRef.reset();

                /*Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const MainMenu(),
                  ),
                );*/
              },
              child: const Text('Kampf abbrechen'),
            ),
          ),
        ],
      ),
    );
  }
}