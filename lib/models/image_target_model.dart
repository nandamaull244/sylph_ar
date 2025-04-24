class ImageTargetModel {
  final String id;
  final String userId;
  final String name;
  final String imageUrl;

  ImageTargetModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.imageUrl,
  });

  factory ImageTargetModel.fromJson(Map<String, dynamic> json) {
    return ImageTargetModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      imageUrl: json['image_url'],
    );
  }
}
