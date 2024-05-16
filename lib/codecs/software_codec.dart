import '../entities/_software.dart';

abstract interface class SoftwareCodec {
  String get name;

  void write(List<Software> software);

  List<Software> read();
}
