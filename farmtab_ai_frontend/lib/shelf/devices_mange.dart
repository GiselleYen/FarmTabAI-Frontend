import 'package:flutter/material.dart';

class DevicesMangePage extends StatefulWidget {
  const DevicesMangePage({super.key});

  @override
  State<DevicesMangePage> createState() => _DevicesMangePageState();
}

class _DevicesMangePageState extends State<DevicesMangePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Management'),
      ),
      body: const Center(
        child: Text(
          'This is the Device Management Page',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

