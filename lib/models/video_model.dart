class VideoModel {
  final String id;
  final String userId;
  final String imageTargetId;
  final String videoUrl;

  VideoModel({
    required this.id,
    required this.userId,
    required this.imageTargetId,
    required this.videoUrl,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      userId: json['user_id'],
      imageTargetId: json['image_target_id'],
      videoUrl: json['video_url'],
    );
  }
}
