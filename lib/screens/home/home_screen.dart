import 'package:flutter/material.dart';
import '../../services/board_service.dart';
import '../../models/board_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<BoardModel> boards = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadBoards();
  }

  Future<void> loadBoards() async {
    final data = await BoardService.getBoards();
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

              await BoardService.createBoard(title);
              Navigator.pop(context);
              loadBoards();
            },
            child: const Text("Crear"),
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
              : ListView.builder(
                  itemCount: boards.length,
                  itemBuilder: (_, i) {
                    final b = boards[i];
                    return ListTile(
                      title: Text(b.title),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "/board",
                          arguments: b,
                        );
                      },
                    );
                  },
                ),
    );
  }
}
