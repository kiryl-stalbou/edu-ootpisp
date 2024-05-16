import '../entities/_software.dart';

abstract interface class SoftwareCodec {
  void write(List<Software> software);

  List<Software> read();
}
