import 'package:flutter/material.dart';

/// Pantalla de Detalles de Tarjeta
class CardDetailsScreen extends StatelessWidget {
  const CardDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Tarjeta'),
      ),
      body: const Center(
        child: Text('Detalles de la Tarjeta'),
      ),
    );
  }
}
