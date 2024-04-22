import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:serious_python/serious_python.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final logger = Logger();
  Timer? timer;
  String? pyResult;

  void _runPython() async {
    try {
      Directory tempDir =
          await (await getTemporaryDirectory()).createTemp('run_example');

      String resultFileName = join(tempDir.path, 'out.txt');
      String resultValue = DateTime.now().toIso8601String();

      await SeriousPython.run(
        'assets/python/main.py',
        environmentVariables: {
          "RESULT_FILENAME": resultFileName,
          "RESULT_VALUE": resultValue
        },
        sync: false,
      );

      final out = File(resultFileName);
      final result = await out.readAsString();
      pyResult = 'Result: $result';
    } catch (error) {
      pyResult = 'Error: $error';
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _runPython();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Python'),
      ),
      body: Center(
        child: Text(
          pyResult ?? '...........',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
