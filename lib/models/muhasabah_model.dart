class MuhasabahModel {
  final int id;
  final int userId;
  final String title;
  final String content;
  final String? mood;
  final String tanggal;
  final String? createdAt;

  MuhasabahModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.mood,
    required this.tanggal,
    this.createdAt,
  });

  factory MuhasabahModel.fromJson(Map<String, dynamic> json) {
    return MuhasabahModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      content: json['content'],
      mood: json['mood'],
      tanggal: json['tanggal'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'mood': mood,
      'tanggal': tanggal,
    };
  }
}