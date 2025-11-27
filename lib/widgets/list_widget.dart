import 'package:flutter/material.dart';
import '../models/list_model.dart';

/// Widget de Lista
class ListWidget extends StatelessWidget {
  final ListModel list;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const ListWidget({
    Key? key,
    required this.list,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  list.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
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
        ),
      ),
    );
  }
}
