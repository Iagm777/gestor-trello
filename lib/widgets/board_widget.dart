import 'package:flutter/material.dart';
import '../models/board_model.dart';

class BoardWidget extends StatelessWidget {
  final BoardModel board;
  final VoidCallback onTap;

  const BoardWidget({
    super.key,
    required this.board,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          board.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
