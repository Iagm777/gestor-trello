import 'package:flutter/material.dart';
import '../services/board_service.dart';
import '../services/auth_service.dart';
import '../models/board_model.dart';

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
    final user = AuthService.currentUser;

    if (user == null) return;

    final data = await BoardService.getBoards(user.id);

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
        title: const Text('Nuevo tablero'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Título del tablero',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = controller.text.trim();
              if (title.isEmpty) return;

              final user = AuthService.currentUser;
              await BoardService.createBoard(title, user!.id);

              Navigator.pop(context);
              loadBoards();
            },
            child: const Text('Crear'),
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
        actions: [
          IconButton(
            onPressed: () {
              AuthService.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openCreateBoardDialog,
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : boards.isEmpty
              ? const Center(child: Text("No tienes tableros aún"))
              : ListView.builder(
                  itemCount: boards.length,
                  itemBuilder: (_, i) {
                    final board = boards[i];
                    return ListTile(
                      title: Text(board.title),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/board',
                          arguments: board,
                        );
                      },
                    );
                  },
                ),
    );
  }
}
