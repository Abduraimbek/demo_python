import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:serious_python/serious_python.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final logger = Logger();

  void _show(
    String title,
    String message,
  ) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }
  }

  void _runPython() async {
    try {
      final result = await SeriousPython.run(
        'assets/python/main.zip',
        environmentVariables: {
          'a': '1',
          'b': '2',
        },
      );

      _show('Natija', '$result');
    } catch (error) {
      _show('Error', error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Python'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _runPython,
          child: const Text('Press me'),
        ),
      ),
    );
  }
}
