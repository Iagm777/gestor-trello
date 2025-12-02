import 'package:flutter/material.dart';
import '../../models/card_model.dart';
import '../../services/card_service.dart';

class CardDetailsScreen extends StatefulWidget {
  const CardDetailsScreen({super.key});

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  late CardModel card;
  late TextEditingController titleCtrl;
  late TextEditingController descCtrl;
  bool loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // recibe el CardModel por argumentos de la ruta
    card = ModalRoute.of(context)!.settings.arguments as CardModel;
    titleCtrl = TextEditingController(text: card.title);
    descCtrl = TextEditingController(text: card.description ?? '');
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => loading = true);
    await CardService.updateCard(card.id, titleCtrl.text.trim(), descCtrl.text.trim());
    setState(() => loading = false);
    Navigator.pop(context, true); // indica que hubo cambios
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar tarjeta'),
        content: const Text('¿Estás seguro que quieres eliminar esta tarjeta?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Eliminar')),
        ],
      ),
    );

    if (ok == true) {
      await CardService.deleteCard(card.id);
      Navigator.pop(context, true); // devolver true para refrescar
    }
  }

  // Shortcut to open edit screen (optional)
  Future<void> _openEdit() async {
    final changed = await Navigator.pushNamed(context, '/card-edit', arguments: card);
    if (changed == true) {
      // reload card from server if needed; here we just pop true upward to refresh lists
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de tarjeta'),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _openEdit),
          IconButton(icon: const Icon(Icons.delete), onPressed: _delete),
          IconButton(icon: const Icon(Icons.save), onPressed: loading ? null : _save),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  const Text('Título', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(controller: titleCtrl),
                  const SizedBox(height: 16),
                  const Text('Descripción', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(controller: descCtrl, maxLines: 6),
                ],
              ),
            ),
    );
  }
}
