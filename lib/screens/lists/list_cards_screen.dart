import 'package:flutter/material.dart';

/// Pantalla de Tarjetas de una Lista
class ListCardsScreen extends StatelessWidget {
  const ListCardsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarjetas'),
      ),
      body: const Center(
        child: Text('Lista de Tarjetas'),
      ),
    );
  }
}
