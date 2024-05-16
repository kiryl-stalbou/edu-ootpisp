import 'dart:io';

import 'package:flutter/services.dart';
import '../software_codec.dart';
import '../../entities/_software.dart';

final class SoftwareBinaryCodec implements SoftwareCodec {
  static const _codec = StandardMessageCodec();
  static final _file = File('lib/software.bin');

  @override
  String get name => 'Binary';

  @override
  void write(List<Software> software) {
    final bytes =
        _codec.encodeMessage(software.map((e) => e.toObjects()).toList()) ??
            ByteData(0);
    _file.writeAsBytesSync(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
  }

  @override
  List<Software> read() {
    final bytes = _file.readAsBytesSync().buffer.asByteData();
    if (bytes.lengthInBytes == 0) return [];
    final objects = _codec.decodeMessage(bytes) as List<Object?>;
    return objects
        .map((e) => Software.fromObjects(e as List<Object?>))
        .toList();
  }
}
