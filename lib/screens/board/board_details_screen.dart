import 'package:flutter/material.dart';

/// Pantalla de Detalles del Tablero
class BoardDetailsScreen extends StatelessWidget {
  const BoardDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Tablero'),
      ),
      body: const Center(
        child: Text('Detalles del Tablero'),
      ),
    );
  }
}
