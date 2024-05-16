import 'package:lab2/entities/internet_browser.dart';
import 'package:lab2/entities/music_player.dart';
import 'package:lab2/entities/operating_system.dart';
import 'package:lab2/factories/software_factory.dart';

final class SoftwareMacOSFactory implements SoftwareFactory {
  static const _dimension = 50.0;
  static const _iconColor = 0xffffffff;
  static const _color = 0xff000000;
  static const _cornerRadius = 8.0;

  @override
  String get name => 'MacOS';

  @override
  InternetBrowser createInternetBrowser() => const InternetBrowser(
        name: 'Internet Browser (MacOS)',
        cornerRadius: _cornerRadius,
        dimension: _dimension,
        iconColor: _iconColor,
        color: _color,
        icon: 0xf83f,
      );

  @override
  MusicPlayer createMusicPlayer() => const MusicPlayer(
        name: 'Music Player (MacOS)',
        cornerRadius: _cornerRadius,
        dimension: _dimension,
        iconColor: _iconColor,
        color: _color,
        icon: 0xf8ed,
      );

  @override
  OperatingSystem createOperatingSystem() => const OperatingSystem(
        name: 'Operating System (MacOS)',
        cornerRadius: _cornerRadius,
        dimension: _dimension,
        iconColor: _iconColor,
        color: _color,
        icon: 0xf02d8,
      );
}
