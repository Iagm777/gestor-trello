import 'board_model.dart';

/// Modelo de Lista
class ListModel {
  final String id;
  final String title;
  final String boardId;
  final int position;
  final BoardModel? board;
  final DateTime createdAt;
  final DateTime updatedAt;

  ListModel({
    required this.id,
    required this.title,
    required this.boardId,
    required this.position,
    this.board,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'board_id': boardId,
      'position': position,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Crea una instancia desde JSON
  factory ListModel.fromJson(Map<String, dynamic> json) {
    return ListModel(
      id: json['id'] as String,
      title: json['title'] as String,
      boardId: json['board_id'] as String,
      position: json['position'] as int,
      board: json['board'] != null ? BoardModel.fromJson(json['board']) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Copia el modelo con cambios opcionales
  ListModel copyWith({
    String? id,
    String? title,
    String? boardId,
    int? position,
    BoardModel? board,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ListModel(
      id: id ?? this.id,
      title: title ?? this.title,
      boardId: boardId ?? this.boardId,
      position: position ?? this.position,
      board: board ?? this.board,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
