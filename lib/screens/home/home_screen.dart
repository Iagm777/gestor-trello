import 'package:flutter/material.dart';
import '../../services/board_service.dart';
import '../../models/board_model.dart';
import '../../widgets/board_widget.dart';
import '../../config/supabase_config.dart';

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

    // Debug
    // ignore: avoid_print
    print('loadBoards (home): found ${boards.length} boards for user ${user.id}');
  } catch (e) {
    if (!mounted) return;
    setState(() {
      loading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error cargando tableros: $e')));
  }
  }

  void openCreateBoardDialog() {
    final controller = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setStateDialog) => AlertDialog(
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
                        // If no user, redirect to login screen instead of showing a snackbar.
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) Navigator.pushReplacementNamed(context, '/login');
                        });
                        return;
                      }

                      setStateDialog(() => isLoading = true);

                      try {
                        final created = await BoardService.createBoard(title, user.id);
                        if (created != null) {
                          if (mounted) {
                            setState(() {
                              boards.insert(0, created);
                            });
                          }
                          // Show confirmation SnackBar with created id/title
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tablero creado: ${created.title} (id ${created.id})')));
                          Navigator.pop(context, true);
                        } else {
                          setStateDialog(() => isLoading = false);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo crear el tablero')));
                        }
                      } catch (e) {
                        setStateDialog(() => isLoading = false);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al crear tablero: $e')));
                      }
                    },
                    child: const Text("Crear"),
                  ),
          ],
        ),
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
    final user = SupabaseConfig.client.auth.currentUser;

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
          : Column(
              children: [
                // Debug header: show user id and board count
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('User: ${user?.id ?? "(none)"}    Boards: ${boards.length}'),
                      ),
                      IconButton(
                        tooltip: 'Refrescar',
                        icon: const Icon(Icons.refresh),
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          await loadBoards();
                        },
                      ),
                      IconButton(
                        tooltip: 'Debug: fetch all boards',
                        icon: const Icon(Icons.storage),
                        onPressed: () async {
                          try {
                            final all = await BoardService.getAllBoards();
                            // ignore: avoid_print
                            print('getAllBoards: found ${all.length} total boards');
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Total boards in DB: ${all.length}')));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching all boards: $e')));
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: boards.isEmpty
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
                ),
              ],
            ),
    );
  }
}
