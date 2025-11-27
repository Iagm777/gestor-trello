import 'package:flutter/material.dart';
import '../models/card_model.dart';

/// Widget de Tarjeta
class CardWidget extends StatelessWidget {
  final CardModel card;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const CardWidget({
    Key? key,
    required this.card,
    required this.onTap,
    this.onDelete,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      card.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      if (onEdit != null)
                        PopupMenuItem(
                          child: const Text('Editar'),
                          onTap: onEdit,
                        ),
                      if (onDelete != null)
                        PopupMenuItem(
                          child: const Text('Eliminar'),
                          onTap: onDelete,
                        ),
                    ],
                  ),
                ],
              ),
              if (card.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  card.description!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (card.dueDate != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Vence: ${card.dueDate}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.red,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
