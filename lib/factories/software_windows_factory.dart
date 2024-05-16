import 'package:lab2/entities/internet_browser.dart';
import 'package:lab2/entities/music_player.dart';
import 'package:lab2/entities/operating_system.dart';
import 'package:lab2/factories/software_factory.dart';

final class SoftwareWindowsFactory implements SoftwareFactory {
  static const _iconColor = 0xffffffff;
  static const _color = 0xffff448aff;
  static const _cornerRadius = 0.0;
  static const _dimension = 50.0;

  @override
  String get name => 'Windows';

  @override
  InternetBrowser createInternetBrowser() => const InternetBrowser(
        name: 'Internet Browser (Windows)',
        cornerRadius: _cornerRadius,
        dimension: _dimension,
        iconColor: _iconColor,
        color: _color,
        icon: 0xf83f,
      );

  @override
  MusicPlayer createMusicPlayer() => const MusicPlayer(
        name: 'Music Player (Windows)',
        cornerRadius: _cornerRadius,
        dimension: _dimension,
        iconColor: _iconColor,
        color: _color,
        icon: 0xeb0e,
      );

  @override
  OperatingSystem createOperatingSystem() => const OperatingSystem(
        icon: 0xede4,
        name: 'Operating System (Windows)',
        cornerRadius: _cornerRadius,
        dimension: _dimension,
        iconColor: _iconColor,
        color: _color,
      );
}
