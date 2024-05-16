// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_import

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lab2/codecs/ffi/software_ffi_codec.dart';
import 'package:lab2/codecs/json/software_json_codec.dart';
import 'package:lab2/codecs/software_codec.dart';
import 'codecs/binary/software_binary_codec.dart';
import 'entities/_software.dart';
import 'factories/software_macos_factory.dart';
import 'factories/software_factory.dart';
import 'factories/software_windows_factory.dart';

// clang++ -dynamiclib -o example.dylib example.cpp

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Software> _software = [];

  final List<SoftwareFactory> _availableSoftwareFactories = [
    SoftwareWindowsFactory(),
    SoftwareMacOSFactory(),
  ];

  final List<SoftwareCodec> _availableSoftwareCodecs = [
    SoftwareJsonCodec(),
    SoftwareBinaryCodec(),
  ];

  late SoftwareFactory? _selectedSoftwareFactory =
      _availableSoftwareFactories.firstOrNull;

  late SoftwareCodec? _selectedSoftwareCodec =
      _availableSoftwareCodecs.firstOrNull;

  void _onSoftwareFactorySelected(int target) {
    setState(() {
      _selectedSoftwareFactory = _availableSoftwareFactories[target];
    });
  }

  void _onSoftwareCodecSelected(int target) {
    setState(() {
      _selectedSoftwareCodec = _availableSoftwareCodecs[target];
    });

    _readSoftware();
  }

  void _readSoftware() {
    if (_selectedSoftwareCodec == null) return;

    _software = _selectedSoftwareCodec!.read();
  }

  void _addSoftware(Software? software) {
    if (software == null) return;

    setState(() => _software.add(software));

    _selectedSoftwareCodec?.write(_software);
  }

  void _clearSoftware() {
    setState(() => _software.clear());

    _selectedSoftwareCodec?.write(_software);
  }

  void _searchFFICodecFiles() {
    final systemEntities =
        Directory('lib/codecs/ffi').listSync(recursive: true);

    for (var systemEntity in systemEntities) {
      if (systemEntity is File && systemEntity.path.endsWith('codec.dylib')) {
        final parentDirectoryName = systemEntity.parent.path.split('/').last;

        _availableSoftwareCodecs.add(
          CodecFFI(
            name: parentDirectoryName,
            dylibPath: systemEntity.path,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _searchFFICodecFiles();

    _readSoftware();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Row(
          children: [
            //
            Expanded(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (var i = 0; i < _software.length; i++)
                    SizedBox.square(
                      dimension: _software[i].dimension,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(_software[i].color),
                          borderRadius: BorderRadius.all(
                            Radius.circular(_software[i].cornerRadius),
                          ),
                        ),
                        child: Icon(
                          IconData(
                            _software[i].icon,
                            fontFamily: 'MaterialIcons',
                          ),
                          color: Color(_software[i].iconColor),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            ColoredBox(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: SizedBox(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //
                      const Text('Current Platform'),

                      const SizedBox(height: 5),

                      _ToggleButtons(
                        direction: Axis.horizontal,
                        isSelected: _availableSoftwareFactories
                            .map((e) => e == _selectedSoftwareFactory)
                            .toList(),
                        onPressed: _onSoftwareFactorySelected,
                        children: _availableSoftwareFactories
                            .map((e) => Text(e.name))
                            .toList(),
                      ),

                      const SizedBox(height: 20),

                      if (_availableSoftwareCodecs.isEmpty)
                        const Text('Codecs not found')
                      else ...[
                        //
                        const Text('Current Codec'),

                        const SizedBox(height: 5),

                        _ToggleButtons(
                          direction: Axis.vertical,
                          isSelected: _availableSoftwareCodecs
                              .map((e) => e == _selectedSoftwareCodec)
                              .toList(),
                          onPressed: _onSoftwareCodecSelected,
                          children: _availableSoftwareCodecs
                              .map((e) => Text(e.name))
                              .toList(),
                        ),
                      ],

                      const SizedBox(height: 30),

                      ElevatedButton(
                        onPressed: () => _addSoftware(
                          _selectedSoftwareFactory?.createMusicPlayer(),
                        ),
                        child: const Text('Create Music Player'),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () => _addSoftware(
                          _selectedSoftwareFactory?.createInternetBrowser(),
                        ),
                        child: const Text('Create Internet Browser'),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () => _addSoftware(
                          _selectedSoftwareFactory?.createOperatingSystem(),
                        ),
                        child: const Text('Create Operating System'),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: _clearSoftware,
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class _ToggleButtons extends StatelessWidget {
  const _ToggleButtons({
    required this.direction,
    required this.isSelected,
    required this.onPressed,
    required this.children,
  });

  final Axis direction;
  final List<bool> isSelected;
  final void Function(int) onPressed;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      onPressed: onPressed,
      isSelected: isSelected,
      direction: direction,
      constraints: const BoxConstraints(
        minHeight: 40.0,
        minWidth: 80.0,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      selectedBorderColor: Colors.blue[700],
      selectedColor: Colors.white,
      fillColor: Colors.blue[200],
      color: Colors.blue[400],
      children: children,
    );
  }
}
