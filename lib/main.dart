// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_import

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lab2/codecs_ffi/codec_ffi.dart';
import 'entities/_software.dart';
import 'factories/software_macos_factory.dart';
import 'factories/software_factory.dart';
import 'factories/software_windows_factory.dart';

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
  final _software = <Software>[];
  SoftwareFactory _softwareFactory = SoftwareWindowsFactory();

  final _supportedPlatforms = <Widget>[
    Text('Windows'),
    Text('MacOS'),
  ];

  final _selectedPlatforms = <bool>[
    true,
    false,
  ];

  late final List<File> _codecFiles;

  late final List<Widget> _supportedCodecs =
      _listCodecFiles().map((e) => e.path.split('/').last);

  late final List<bool> _selectedCodecs = <bool>[
    true,
    false,
  ];

  void _onPlatformSelected(int index) {
    setState(() {
      for (int i = 0; i < _selectedPlatforms.length; i++) {
        _selectedPlatforms[i] = i == index;
      }

      _softwareFactory =
          index == 0 ? SoftwareWindowsFactory() : SoftwareMacOSFactory();
    });
  }

  void _onCodecSelected(int index) {}

  void _addSoftware(Software software) =>
      setState(() => _software.add(software));

  void _clearSoftware() => setState(() => _software.clear());

  List<File> _listCodecFiles() {
    final systemEntities =
        Directory('lib/codecs_ffi').listSync(recursive: true);

    final codecFiles = <File>[];

    for (var systemEntity in systemEntities) {
      if (systemEntity is File && systemEntity.path.endsWith('.dylib')) {
        codecFiles.add(systemEntity);
      }
    }

    return codecFiles;
  }

  @override
  void initState() {
    super.initState();

    _codecFiles = _listCodecFiles();
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
                        isSelected: _selec,
                        onPressed: _onPlatformSelected,
                        children: _supportedPlatforms,
                      ),

                      const SizedBox(height: 20),

                      const Text('Current Codec'),

                      const SizedBox(height: 5),

                      _ToggleButtons(
                        direction: Axis.vertical,
                        isSelected: _selectedPlatforms,
                        onPressed: _onPlatformSelected,
                        children: _supportedPlatforms,
                      ),

                      const SizedBox(height: 30),

                      ElevatedButton(
                        onPressed: () => _addSoftware(
                          _softwareFactory.createMusicPlayer(),
                        ),
                        child: const Text('Create Music Player'),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () => _addSoftware(
                          _softwareFactory.createInternetBrowser(),
                        ),
                        child: const Text('Create Internet Browser'),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () => _addSoftware(
                          _softwareFactory.createOperatingSystem(),
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
