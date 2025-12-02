class BoardModel {
  final int id;
  final String title;
  final String userId;

  BoardModel({
    required this.id,
    required this.title,
    required this.userId,
  });

  factory BoardModel.fromJson(Map<String, dynamic> json) {
    return BoardModel(
      id: json['id'],
      title: json['title'],
      userId: json['user_id'],
    );
  }
}
