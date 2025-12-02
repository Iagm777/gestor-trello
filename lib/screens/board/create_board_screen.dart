import 'package:flutter/material.dart';
import '../../services/board_service.dart';
import '../../config/supabase_config.dart';

class CreateBoardScreen extends StatefulWidget {
  const CreateBoardScreen({super.key});

  @override
  State<CreateBoardScreen> createState() => _CreateBoardScreenState();
}

class _CreateBoardScreenState extends State<CreateBoardScreen> {
  final controller = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    // Get userId from arguments or from authenticated user
    String? userId = ModalRoute.of(context)?.settings.arguments as String?;
    if (userId == null) {
      final user = SupabaseConfig.client.auth.currentUser;
      userId = user?.id;
      if (userId == null) {
        // No authenticated user found — navigate to login so user can authenticate
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) Navigator.pushReplacementNamed(context, '/login');
        });
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo tablero")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Título del tablero",
              ),
            ),

            const SizedBox(height: 20),

            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    child: const Text("Crear"),
                    onPressed: () async {
                      if (controller.text.isEmpty) return;
                      if (userId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Error: No user found")),
                        );
                        return;
                      }

                      setState(() => loading = true);

                      await BoardService.createBoard(
                        controller.text.trim(),
                        userId,
                      );

                      Navigator.pop(context, true);
                    },
                  )
          ],
        ),
      ),
    );
  }
}
