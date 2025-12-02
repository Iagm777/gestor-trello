import 'package:flutter/material.dart';
import '../../services/card_service.dart';

class CreateCardScreen extends StatefulWidget {
  final int listId;
  const CreateCardScreen({super.key, required this.listId});

  @override
  State<CreateCardScreen> createState() => _CreateCardScreenState();
}

class _CreateCardScreenState extends State<CreateCardScreen> {
  final controller = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final title = controller.text.trim();
    if (title.isEmpty) return;

    setState(() => loading = true);
    await CardService.createCard(title, widget.listId);
    setState(() => loading = false);
    Navigator.pop(context, true); // devuelve true para refrescar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear tarjeta')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 20),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _create,
                    child: const Text('Crear'),
                  )
          ],
        ),
      ),
    );
  }
}
