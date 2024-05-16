import 'dart:convert';
import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';
import 'package:lab2/codecs/software_codec.dart';

import '../../entities/_software.dart';

typedef DartWriteFunc = void Function(ffi.Pointer<Utf8>);
typedef CppWriteFunc = ffi.Void Function(ffi.Pointer<Utf8>);

typedef DartReadFunc = ffi.Pointer<Utf8> Function();
typedef CppReadFunc = ffi.Pointer<Utf8> Function();

class CodecFFI implements SoftwareCodec {
  CodecFFI({
    required this.name,
    required String dylibPath,
  }) : _dylib = ffi.DynamicLibrary.open(dylibPath);

  final ffi.DynamicLibrary _dylib;

  @override
  final String name;

  @override
  void write(List<Software> software) {
    final string = jsonEncode(software);

    final writeffi =
        _dylib.lookupFunction<CppWriteFunc, DartWriteFunc>('write');

    writeffi(string.toNativeUtf8());
  }

  @override
  List<Software> read() {
    final readffi = _dylib.lookupFunction<CppReadFunc, DartReadFunc>('read');

    final string = readffi().toString();

    print(string);

    return [];

    final jsons = jsonDecode(string) as List<Object>;

    print(jsons);

    return jsons
        .map((e) => Software.fromJson(e as Map<String, Object?>))
        .toList();
  }
}
