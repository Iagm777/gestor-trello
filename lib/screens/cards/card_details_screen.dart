import 'package:flutter/material.dart';
import '../../models/card_model.dart';
import '../../services/card_service.dart';

class CardDetailScreen extends StatefulWidget {
  const CardDetailScreen({super.key});

  @override
  State<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  late CardModel card;
  late TextEditingController titleCtrl;
  late TextEditingController descriptionCtrl;

  bool saving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    card = ModalRoute.of(context)!.settings.arguments as CardModel;

    titleCtrl = TextEditingController(text: card.title);
    descriptionCtrl = TextEditingController(text: card.description ?? "");
  }

  Future<void> saveCard() async {
    setState(() => saving = true);

    await CardService.updateCard(
      card.id,
      titleCtrl.text.trim(),
      descriptionCtrl.text.trim(),
    );

    setState(() => saving = false);

    Navigator.pop(context, true);
  }

  // ----------------------------------------
  // LABELS
  // ----------------------------------------
  void openLabelsEditor() {
    final available = ["Rojo", "Azul", "Verde", "Amarillo", "Morado"];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Etiquetas"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: available.map((label) {
            final selected = card.labels.contains(label);
            return CheckboxListTile(
              title: Text(label),
              value: selected,
              onChanged: (checked) async {
                if (checked == true) {
                  card.labels.add(label);
                } else {
                  card.labels.remove(label);
                }

                await CardService.updateLabels(card.id, card.labels);
                setState(() {});
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  // ----------------------------------------
  // DUE DATE
  // ----------------------------------------
  void pickDueDate() async {
    final selected = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: card.dueDate ?? DateTime.now(),
    );

    if (selected != null) {
      await CardService.updateDueDate(card.id, selected);
      setState(() => card = card.copyWith(dueDate: selected));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles de tarjeta"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await CardService.deleteCard(card.id);
              Navigator.pop(context, true);
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: saving ? null : saveCard,
          ),
        ],
      ),

      body: saving
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // TITLE
                const Text("Título", style: TextStyle(fontSize: 18)),
                TextField(controller: titleCtrl),

                const SizedBox(height: 20),

                // DESCRIPTION
                const Text("Descripción", style: TextStyle(fontSize: 18)),
                TextField(
                  controller: descriptionCtrl,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),

                const Divider(height: 40),

                // LABELS
                ListTile(
                  leading: const Icon(Icons.label),
                  title: const Text("Etiquetas"),
                  subtitle: Wrap(
                    spacing: 6,
                    children: card.labels
                        .map((l) => Chip(label: Text(l)))
                        .toList(),
                  ),
                  onTap: openLabelsEditor,
                ),

                const Divider(),

                // DUE DATE
                ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: const Text("Fecha límite"),
                  subtitle: Text(
                    card.dueDate == null
                        ? "Sin fecha"
                        : "${card.dueDate!.day}/${card.dueDate!.month}/${card.dueDate!.year}",
                  ),
                  onTap: pickDueDate,
                ),

                const Divider(),

                // CHECKLIST FEATURE LO DEJAMOS AQUÍ PARA AGREGAR LUEGO
                ListTile(
                  leading: const Icon(Icons.checklist),
                  title: const Text("Checklist"),
                  subtitle: Text(card.hasChecklist
                      ? "Checklist activado"
                      : "Ningún checklist"),
                  onTap: () {},
                ),
              ],
            ),
    );
  }
}
