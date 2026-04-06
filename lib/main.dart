import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'models/settings.dart';
import 'screens/main_menu.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await initHive();

  runApp(MultiProvider(
    providers: [
      FutureProvider<Settings>(
        create: (BuildContext context) => getSettings(),
        initialData: Settings(soundEffects: false, backgroundMusic: false),
      ),
    ],
    builder: (context, child) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<Settings>.value(
            value: Provider.of<Settings>(context),
          ),
        ],
        child: child,
      );
    },
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      // Dark more because we are too cool for white theme.
      themeMode: ThemeMode.dark,
      // Use custom theme with 'BungeeInline' font.
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'BungeeInline',
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const MainMenu(),
    ),
  ));
}

Future<void> initHive() async {
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.registerAdapter(SettingsAdapter());
}

Future<Settings> getSettings() async {
  final box = await Hive.openBox<Settings>(Settings.SETTINGS_BOX);
  final settings = box.get(Settings.SETTINGS_KEY);
  if (settings == null) {
    box.put(
      Settings.SETTINGS_KEY,
      Settings(soundEffects: true, backgroundMusic: true),
    );
  }

  return box.get(Settings.SETTINGS_KEY)!;
}