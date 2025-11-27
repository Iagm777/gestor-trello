import 'user_model.dart';

/// Modelo de Tablero
class BoardModel {
  final String id;
  final String title;
  final String? description;
  final String userId;
  final UserModel? user;
  final DateTime createdAt;
  final DateTime updatedAt;

  BoardModel({
    required this.id,
    required this.title,
    this.description,
    required this.userId,
    this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Crea una instancia desde JSON
  factory BoardModel.fromJson(Map<String, dynamic> json) {
    return BoardModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      userId: json['user_id'] as String,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Copia el modelo con cambios opcionales
  BoardModel copyWith({
    String? id,
    String? title,
    String? description,
    String? userId,
    UserModel? user,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BoardModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
