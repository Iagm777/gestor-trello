class BoardModel {
  // IDs in the Supabase schema may be UUID strings depending on your DB setup.
  // Use dynamic here to accept either int or String and keep code robust.
  final dynamic id;
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
      title: json['title'] ?? '',
      userId: json['user_id'] ?? '',
    );
  }
}
