import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:provider/provider.dart';
import 'package:solarstriker/game/game.dart';

import '../models/settings.dart';

class AudioComponent extends Component with HasGameRef<SolarStrikerGame> {
  @override
  Future<void>? onLoad() async {
    FlameAudio.bgm.initialize();

    await FlameAudio.audioCache.loadAll([
      'background.mp3',
    ]);

    return super.onLoad();
  }

  void playBgm() {
    try {
      if (gameRef.buildContext != null) {
        if (Provider
            .of<Settings>(gameRef.buildContext!, listen: false)
            .backgroundMusic) {
          FlameAudio.bgm.play("background.mp3");
        }
      }
    } catch(exception) {
      print(exception);
    }
  }

  void stopBgm() {
    FlameAudio.bgm.stop();
  }
}