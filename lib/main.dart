// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_import

import 'package:flutter/material.dart';
import 'package:lab2/factories/software_macos_factory.dart';
import 'package:lab2/factories/software_factory.dart';
import 'package:lab2/factories/software_windows_factory.dart';

import 'codec/_codec.dart';
import 'codec/binary_codec.dart' deferred as lib_codec;
import 'entities/_software.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent)),
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
  final List<Widget> _supportedPlatforms = [Text('Windows'), Text('MacOS')];
  final List<bool> _selectedPlatforms = [true, false];

  SoftwareFactory _factory = SoftwareWindowsFactory();
  late SoftwareCodec _codec;

  List<Software> _software = [];

  void _add(Software software) {
    setState(() => _software.add(software));
    _codec.write(_software);
  }

  void _clear() {
    setState(() => _software.clear());
    _codec.write([]);
  }

  @override
  void initState() {
    super.initState();

    lib_codec.loadLibrary().then(print);

    // _codec = lib.
    // _software = _codec.read();
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
                    Tooltip(
                      message: _software[i].name,
                      child: SizedBox.square(
                        dimension: _software[i].dimension,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(_software[i].color),
                            borderRadius: BorderRadius.all(
                              Radius.circular(_software[i].cornerRadius),
                            ),
                          ),
                          child: Icon(
                            IconData(_software[i].icon, fontFamily: 'MaterialIcons'),
                            color: Color(_software[i].iconColor),
                          ),
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

                      const SizedBox(height: 10),

                      ToggleButtons(
                        isSelected: _selectedPlatforms,
                        onPressed: (int index) {
                          setState(() {
                            for (int i = 0; i < _selectedPlatforms.length; i++) {
                              _selectedPlatforms[i] = i == index;
                            }

                            if (index == 0) {
                              _factory = SoftwareWindowsFactory();
                            } else {
                              _factory = SoftwareMacOSFactory();
                            }
                          });
                        },
                        constraints: const BoxConstraints(minHeight: 40.0, minWidth: 80.0),
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        selectedBorderColor: Colors.blue[700],
                        selectedColor: Colors.white,
                        fillColor: Colors.blue[200],
                        color: Colors.blue[400],
                        children: _supportedPlatforms,
                      ),

                      const SizedBox(height: 30),

                      ElevatedButton(
                        onPressed: () => _add(_factory.createMusicPlayer()),
                        child: const Text('Create Music Player'),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () => _add(_factory.createInternetBrowser()),
                        child: const Text('Create Internet Browser'),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () => _add(_factory.createOperatingSystem()),
                        child: const Text('Create Operating System'),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () => _clear(),
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
