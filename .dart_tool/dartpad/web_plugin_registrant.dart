// Flutter web plugin registrant file.
//
// Generated file. Do not edit.
//

// @dart = 2.13
// ignore_for_file: type=lint

import 'package:url_launcher_web/url_launcher_web.dart';
<<<<<<< HEAD
=======
import 'package:video_player_web/video_player_web.dart';
>>>>>>> 290bb0fda70162a419640d145157fa768558024b
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void registerPlugins([final Registrar? pluginRegistrar]) {
  final Registrar registrar = pluginRegistrar ?? webPluginRegistrar;
  UrlLauncherPlugin.registerWith(registrar);
<<<<<<< HEAD
=======
  VideoPlayerPlugin.registerWith(registrar);
>>>>>>> 290bb0fda70162a419640d145157fa768558024b
  registrar.registerMessageHandler();
}
