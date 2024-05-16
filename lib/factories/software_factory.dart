import 'package:lab2/entities/internet_browser.dart';
import 'package:lab2/entities/music_player.dart';
import 'package:lab2/entities/operating_system.dart';

abstract interface class SoftwareFactory {
  String get name;
  
  OperatingSystem createOperatingSystem();

  InternetBrowser createInternetBrowser();

  MusicPlayer createMusicPlayer();

}
