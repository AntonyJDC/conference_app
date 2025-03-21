import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conference App')),
      body: Center(
        child: Text(
          'Modo actual: ${Theme.of(context).brightness == Brightness.dark ? 'Dark Mode' : 'Light Mode'}',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
