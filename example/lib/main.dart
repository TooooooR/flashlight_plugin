import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flashlight_plugin/flashlight_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _status = 'Torch is off';

  Future<void> _toggleTorch() async {
    try {
      final isOn = await FlashlightPlugin.onLight();
      if (!mounted) return;
      setState(() {
        _status = isOn ? 'Torch is on' : 'Torch is off';
      });
    } on PlatformException {
      if (!mounted) return;
      setState(() {
        _status = 'Torch not available';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_status),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _toggleTorch,
                child: const Text('Toggle torch'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
