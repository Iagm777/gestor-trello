import 'package:flutter/material.dart';

/// Pantalla de Tablero
class BoardScreen extends StatelessWidget {
  const BoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tablero'),
      ),
      body: const Center(
        child: Text('Pantalla de Tablero'),
      ),
    );
  }
}
