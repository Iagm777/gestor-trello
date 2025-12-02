import 'package:flutter/material.dart';
import '../../models/board_model.dart';
import '../../services/board_service.dart';

class EditBoardScreen extends StatefulWidget {
  const EditBoardScreen({super.key});

  @override
  State<EditBoardScreen> createState() => _EditBoardScreenState();
}

class _EditBoardScreenState extends State<EditBoardScreen> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final board = ModalRoute.of(context)!.settings.arguments as BoardModel;
    controller.text = board.title;

    return Scaffold(
      appBar: AppBar(title: const Text("Editar Tablero")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: "Título"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              child: const Text("Guardar"),
              onPressed: () async {
                await BoardService.updateBoard(board.id, controller.text.trim());
                Navigator.pop(context, true);
              },
            )
          ],
        ),
      ),
    );
  }
}
