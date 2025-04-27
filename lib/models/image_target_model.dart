class ImageTargetModel {
  final String id;
  final String userId;
  final String name;
  final String imageUrl;
  final String? createdAt;

  ImageTargetModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.imageUrl,
    this.createdAt,
  });

  factory ImageTargetModel.fromJson(Map<String, dynamic> json) {
    return ImageTargetModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      imageUrl: json['image_url'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at']).toIso8601String()
          : '',
    );
  }
}
