import 'package:flutter/material.dart';
import '../../models/card_model.dart';
import '../../services/card_service.dart';

class EditCardScreen extends StatefulWidget {
	final CardModel card;
	const EditCardScreen({super.key, required this.card});

	@override
	State<EditCardScreen> createState() => _EditCardScreenState();
}

class _EditCardScreenState extends State<EditCardScreen> {
	late TextEditingController titleCtrl;
	late TextEditingController descCtrl;
	bool saving = false;

	@override
	void initState() {
		super.initState();
		titleCtrl = TextEditingController(text: widget.card.title);
		descCtrl = TextEditingController(text: widget.card.description ?? '');
	}

	@override
	void dispose() {
		titleCtrl.dispose();
		descCtrl.dispose();
		super.dispose();
	}

	Future<void> _save() async {
		setState(() => saving = true);
		await CardService.updateCard(widget.card.id, titleCtrl.text.trim(), descCtrl.text.trim());
		setState(() => saving = false);
		Navigator.pop(context, true);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Editar tarjeta'),
				actions: [
					IconButton(
						icon: const Icon(Icons.save),
						onPressed: saving ? null : _save,
					)
				],
			),
			body: Padding(
				padding: const EdgeInsets.all(16),
				child: Column(
					children: [
						TextField(
							controller: titleCtrl,
							decoration: const InputDecoration(labelText: 'Título'),
						),
						const SizedBox(height: 12),
						TextField(
							controller: descCtrl,
							decoration: const InputDecoration(labelText: 'Descripción'),
							maxLines: 5,
						),
						const SizedBox(height: 20),
						saving ? const CircularProgressIndicator() : const SizedBox.shrink(),
					],
				),
			),
		);
	}
}
