class ArtworkModel {
  final String id;
  final String userId;
  final String imageTargetId;
  final String videoId;
  final String title;
  final DateTime createdAt;

  ArtworkModel({
    required this.id,
    required this.userId,
    required this.imageTargetId,
    required this.videoId,
    required this.title,
    required this.createdAt,
  });

  factory ArtworkModel.fromJson(Map<String, dynamic> json) {
    return ArtworkModel(
      id: json['id'],
      userId: json['user_id'],
      imageTargetId: json['image_target_id'],
      videoId: json['video_id'],
      title: json['title'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
