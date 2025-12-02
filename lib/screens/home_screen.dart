import 'package:flutter/material.dart';
import '../services/board_service.dart';
import '../config/supabase_config.dart';
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

  // ======================================================
  // CARGAR TABLEROS DEL USUARIO AUTENTICADO
  // ======================================================
  Future<void> loadBoards() async {
    final user = SupabaseConfig.client.auth.currentUser;

  if (user == null) {
    // No authenticated user: stop loading and redirect to login.
    if (mounted) {
      setState(() {
        loading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pushReplacementNamed(context, '/login');
      });
    }
    return;
  }

  try {
    final data = await BoardService.getBoards(user.id);

    if (!mounted) return;

    setState(() {
      boards = data;
      loading = false;
    });
    // Debug log
    // ignore: avoid_print
    print('loadBoards: found ${boards.length} boards for user ${user.id}');
  } catch (e) {
    if (!mounted) return;
    setState(() {
      loading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error cargando tableros: $e')));
  }
  }

  // ======================================================
  // DIALOGO PARA CREAR UN NUEVO TABLERO
  // ======================================================
  void openCreateBoardDialog() {
    final controller = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setStateDialog) => AlertDialog(
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
            isLoading
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      final title = controller.text.trim();
                      if (title.isEmpty) return;

                      final user = SupabaseConfig.client.auth.currentUser;
                      if (user == null) {
                        Navigator.pop(context);
                        // If no user, redirect to login so the user can authenticate.
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) Navigator.pushReplacementNamed(context, '/login');
                        });
                        return;
                      }

                      setStateDialog(() => isLoading = true);

                      try {
                        await BoardService.createBoard(title, user.id);
                        // Refresh boards before closing the dialog to ensure UI updates.
                        await loadBoards();
                        Navigator.pop(context, true);
                      } catch (e) {
                        setStateDialog(() => isLoading = false);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al crear tablero: $e')));
                      }
                    },
                    child: const Text('Crear'),
                  ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // UI PRINCIPAL
  // ======================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Tableros"),
        actions: [
          IconButton(
            onPressed: () {
              SupabaseConfig.client.auth.signOut();
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
                      trailing: const Icon(Icons.arrow_forward_ios),
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
