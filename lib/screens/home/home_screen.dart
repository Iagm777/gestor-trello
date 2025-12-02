import 'package:flutter/material.dart';
import '../../services/board_service.dart';
import '../../models/board_model.dart';
import '../../widgets/board_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<BoardModel> boards = [];
  bool loading = true;

  // Dummy user ID for now (replace with real auth later)
  final int currentUserId = 1;

  @override
  void initState() {
    super.initState();
    loadBoards();
  }

  Future<void> loadBoards() async {
    final data = await BoardService.getBoards(currentUserId);
    setState(() {
      boards = data;
      loading = false;
    });
  }

  void openCreateBoardDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nuevo tablero"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Nombre del tablero"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = controller.text.trim();
              if (title.isEmpty) return;

              await BoardService.createBoard(title, currentUserId);
              Navigator.pop(context);
              loadBoards();
            },
            child: const Text("Crear"),
          ),
        ],
      ),
    );
  }

  void deleteBoard(BoardModel board) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar tablero"),
        content: Text("¿Eliminar '${board.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              await BoardService.deleteBoard(board.id);
              Navigator.pop(context);
              loadBoards();
            },
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Tableros"),
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: openCreateBoardDialog,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : boards.isEmpty
              ? const Center(child: Text("No tienes tableros"))
              : ListView(
                  children: boards
                      .map((b) => BoardWidget(
                            board: b,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                "/board",
                                arguments: b,
                              );
                            },
                          ))
                      .toList(),
                ),
    );
  }
}
