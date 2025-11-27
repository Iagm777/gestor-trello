import 'list_model.dart';

/// Modelo de Tarjeta
class CardModel {
  final String id;
  final String title;
  final String? description;
  final String listId;
  final int position;
  final String? assignedToUserId;
  final DateTime? dueDate;
  final List<String>? labels;
  final ListModel? list;
  final DateTime createdAt;
  final DateTime updatedAt;

  CardModel({
    required this.id,
    required this.title,
    this.description,
    required this.listId,
    required this.position,
    this.assignedToUserId,
    this.dueDate,
    this.labels,
    this.list,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'list_id': listId,
      'position': position,
      'assigned_to_user_id': assignedToUserId,
      'due_date': dueDate?.toIso8601String(),
      'labels': labels,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Crea una instancia desde JSON
  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      listId: json['list_id'] as String,
      position: json['position'] as int,
      assignedToUserId: json['assigned_to_user_id'] as String?,
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date'] as String) : null,
      labels: json['labels'] != null ? List<String>.from(json['labels'] as List) : null,
      list: json['list'] != null ? ListModel.fromJson(json['list']) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Copia el modelo con cambios opcionales
  CardModel copyWith({
    String? id,
    String? title,
    String? description,
    String? listId,
    int? position,
    String? assignedToUserId,
    DateTime? dueDate,
    List<String>? labels,
    ListModel? list,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CardModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      listId: listId ?? this.listId,
      position: position ?? this.position,
      assignedToUserId: assignedToUserId ?? this.assignedToUserId,
      dueDate: dueDate ?? this.dueDate,
      labels: labels ?? this.labels,
      list: list ?? this.list,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
