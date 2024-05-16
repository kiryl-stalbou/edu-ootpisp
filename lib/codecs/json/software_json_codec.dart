import 'dart:convert';
import 'dart:io';

import 'package:lab2/codecs/software_codec.dart';
import 'package:lab2/entities/_software.dart';

final class SoftwareJsonCodec implements SoftwareCodec {
  static const _codec = JsonCodec();
  static final _file = File('lib/software.json');

  @override
  String get name => 'Json';

  @override
  void write(List<Software> software) {
    final string = _codec.encode(software);
    _file.writeAsStringSync(string);
  }

  @override
  List<Software> read() {
    final string = _file.readAsStringSync();
    if (string.isEmpty) return [];
    final jsons = _codec.decode(string) as List<dynamic>;
    return jsons.map((e) => Software.fromJson(e)).toList();
  }
}
