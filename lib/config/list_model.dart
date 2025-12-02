class ListModel {
  final int id;
  final int boardId;
  final String name;
  final int position;

  ListModel({
    required this.id,
    required this.boardId,
    required this.name,
    required this.position,
  });

  factory ListModel.fromJson(Map<String, dynamic> json) {
    return ListModel(
      id: json['id'] as int,
      boardId: json['board_id'] as int,
      name: json['name'] as String,
      position: json['position'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'board_id': boardId,
      'name': name,
      'position': position,
    };
  }

  ListModel copyWith({
    int? id,
    int? boardId,
    String? name,
    int? position,
  }) {
    return ListModel(
      id: id ?? this.id,
      boardId: boardId ?? this.boardId,
      name: name ?? this.name,
      position: position ?? this.position,
    );
  }
}
