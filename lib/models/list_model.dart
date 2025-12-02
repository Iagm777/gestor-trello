class ListModel {
  final int id;
  final int boardId;
  final String title;
  final int position;

  ListModel({
    required this.id,
    required this.boardId,
    required this.title,
    required this.position,
  });

  factory ListModel.fromJson(Map<String, dynamic> json) {
    return ListModel(
      id: json['id'],
      boardId: json['board_id'],
      title: json['title'],
      position: json['position'],
    );
  }
}
