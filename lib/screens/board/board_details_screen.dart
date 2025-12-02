import 'package:flutter/material.dart';
import '../../models/board_model.dart';

class BoardDetailsScreen extends StatelessWidget {
  const BoardDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final board = ModalRoute.of(context)!.settings.arguments as BoardModel;

    return Scaffold(
      appBar: AppBar(title: Text(board.title)),
      body: Center(
        child: Text("Aquí irán las listas ➜ pantalla BoardScreen real"),
      ),
    );
  }
}
