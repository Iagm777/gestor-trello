class CardModel {
  final dynamic id;
  final String title;
  final String? description;
  final dynamic listId;
  final int position;

  // Features nuevas
  final List<String> labels;
  final bool hasChecklist;
  final DateTime? dueDate;
  final List<String> assignedUsers;

  CardModel({
    required this.id,
    required this.title,
    this.description,
    required this.listId,
    required this.position,
    required this.labels,
    required this.hasChecklist,
    this.dueDate,
    required this.assignedUsers,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      title: json['title'] as String,
      description: json['description'] as String?,
      listId: json['list_id'],
      position: (json['position'] ?? 0) as int,
      labels: (json['labels'] ?? <dynamic>[]).cast<String>(),
      hasChecklist: (json['has_checklist'] ?? false) as bool,
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
      assignedUsers: (json['assigned_users'] ?? <dynamic>[]).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
        'list_id': listId,
      'position': position,
      'labels': labels,
      'has_checklist': hasChecklist,
      'due_date': dueDate?.toIso8601String(),
      'assigned_users': assignedUsers,
    };
  }

  CardModel copyWith({
    dynamic id,
    String? title,
    String? description,
    dynamic listId,
    int? position,
    List<String>? labels,
    bool? hasChecklist,
    DateTime? dueDate,
    List<String>? assignedUsers,
  }) {
    return CardModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      listId: listId ?? this.listId,
      position: position ?? this.position,
      labels: labels ?? List<String>.from(this.labels),
      hasChecklist: hasChecklist ?? this.hasChecklist,
      dueDate: dueDate ?? this.dueDate,
      assignedUsers: assignedUsers ?? List<String>.from(this.assignedUsers),
    );
  }
}
