import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';

typedef DartWriteFunc = void Function(ffi.Pointer<Utf8>);
typedef CppWriteFunc = ffi.Void Function(ffi.Pointer<Utf8>);

typedef DartReadFunc = ffi.Pointer<Utf8> Function();
typedef CppReadFunc = ffi.Pointer<Utf8> Function();

class CodecFFI {
  CodecFFI({required String dylibPath})
      : _dylib = ffi.DynamicLibrary.open(dylibPath);

  final ffi.DynamicLibrary _dylib;

  void write(String string) {
    final writeffi =
        _dylib.lookupFunction<CppWriteFunc, DartWriteFunc>('write');

    writeffi(string.toNativeUtf8());
  }

  String read() {
    final readffi = _dylib.lookupFunction<CppReadFunc, DartReadFunc>('read');

    return readffi().toString();
  }
}
