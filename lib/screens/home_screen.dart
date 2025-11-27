import 'package:flutter/material.dart';

/// Pantalla Principal (Home)
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tableros'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Implementar lógica de logout
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Gestor Trello'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a crear tablero
              },
              child: const Text('Crear Tablero'),
            ),
          ],
        ),
      ),
    );
  }
}
