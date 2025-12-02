import 'package:flutter/material.dart';
import '../../models/board_model.dart';
import '../../models/list_model.dart';
import '../../models/card_model.dart';
import '../../services/list_service.dart';
import '../../services/card_service.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  List<ListModel> lists = [];
  bool loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
  }

  // ==========================================================
  // RENOMBRAR LISTA - DIALOG
  // ==========================================================
  void openRenameListDialog(ListModel list) {
    final controller = TextEditingController(text: list.title);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Renombrar lista"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Nuevo nombre"),
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Guardar"),
            onPressed: () async {
              await ListService.renameList(list.id, controller.text.trim());
              Navigator.pop(context);
              loadData();
            },
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // ELIMINAR LISTA
  // ==========================================================
  Future<void> deleteList(int listId) async {
    await ListService.deleteList(listId);
    loadData();
  }

  // ==========================================================
  // CARGAR LISTAS DEL TABLERO
  // ==========================================================
  Future<void> loadData() async {
    final board =
        ModalRoute.of(context)!.settings.arguments as BoardModel;

    final result = await ListService.getLists(board.id);

    setState(() {
      lists = result;
      loading = false;
    });
  }

  // ==========================================================
  // DIALOGO PARA AGREGAR LISTAS
  // ==========================================================
  void openAddListDialog(int boardId) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Agregar lista'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nombre de la lista',
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

              await ListService.createList(title, boardId);

              Navigator.pop(context);
              loadData();
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // DIALOGO PARA AGREGAR TARJETAS
  // ==========================================================
  void openAddCardDialog(int listId) {
    Navigator.pushNamed(
      context,
      '/card-create',
      arguments: {'listId': listId},
    ).then((result) {
      if (result == true) setState(() {});
    });
  }

  // ==========================================================
  // COLUMNA (LISTA) DE TRELLO COMPLETA
  // ==========================================================
  Widget buildListColumn(ListModel list) {
    return FutureBuilder(
      future: CardService.getCards(list.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            width: 250,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final List<CardModel> cards = snapshot.data as List<CardModel>;

        return Container(
          width: 250,
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade100.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                blurRadius: 6,
                offset: const Offset(0, 3),
                color: Colors.black.withOpacity(0.1),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título de la lista (rename + delete)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => openRenameListDialog(list),
                    child: Text(
                      list.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    onPressed: () => deleteList(list.id),
                  )
                ],
              ),

              const SizedBox(height: 10),

              // ==========================================================
              // TARJETAS: Drag & Drop + Reorder
              // ==========================================================
              Expanded(
                child: DragTarget<CardModel>(
                  onWillAccept: (_) => true,
                  onAccept: (card) async {
                    // MOVER tarjeta desde otra lista
                    await CardService.moveCard(card.id, list.id);
                    setState(() {});
                  },
                  builder: (context, candidate, rejected) {
                    return ReorderableListView(
                      onReorder: (oldIndex, newIndex) async {
                        // Corregir desplazamiento
                        if (newIndex > oldIndex) newIndex--;

                        final updated = List<CardModel>.from(cards);

                        final movedCard = updated.removeAt(oldIndex);
                        updated.insert(newIndex, movedCard);

                        // Guardar nuevas posiciones
                        for (int i = 0; i < updated.length; i++) {
                          await CardService.updatePosition(updated[i].id, i);
                        }

                        setState(() {});
                      },
                      children: [
                        for (int i = 0; i < cards.length; i++)
                          LongPressDraggable<CardModel>(
                            key: ValueKey(cards[i].id),
                            data: cards[i],
                            feedback: Material(
                              color: Colors.transparent,
                              child: Container(
                                width: 220,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                      color: Colors.black26,
                                    )
                                  ],
                                ),
                                child: Text(
                                  cards[i].title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                              child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade300),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 1),
                                    color: Colors.black.withOpacity(0.05),
                                  )
                                ],
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  final changed = await Navigator.pushNamed(
                                    context,
                                    "/card-detail",
                                    arguments: cards[i],
                                  );

                                  if (changed == true) setState(() {});
                                },
                                child: Text(
                                  cards[i].title,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),

              // BOTÓN AGREGAR TARJETA
              TextButton.icon(
                onPressed: () => openAddCardDialog(list.id),
                icon: const Icon(Icons.add),
                label: const Text("Agregar tarjeta"),
              )
            ],
          ),
        );
      },
    );
  }

  // ==========================================================
  // PANTALLA PRINCIPAL
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    final board =
        ModalRoute.of(context)!.settings.arguments as BoardModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(board.title),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => openAddListDialog(board.id),
        child: const Icon(Icons.add),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : lists.isEmpty
              ? const Center(child: Text("No hay listas todavía."))
              : ReorderableListView(
                  scrollDirection: Axis.horizontal,
                  onReorder: (oldIndex, newIndex) async {
                    if (newIndex > oldIndex) newIndex--;

                    final updated = List<ListModel>.from(lists);
                    final moved = updated.removeAt(oldIndex);
                    updated.insert(newIndex, moved);

                    // Actualizar posiciones
                    for (int i = 0; i < updated.length; i++) {
                      await ListService.updatePosition(updated[i].id, i);
                    }

                    setState(() {
                      lists = updated;
                    });
                  },
                  children: [
                    for (int i = 0; i < lists.length; i++)
                      Container(
                        key: ValueKey(lists[i].id),
                        child: buildListColumn(lists[i]),
                      ),
                  ],
                ),
    );
  }
}
