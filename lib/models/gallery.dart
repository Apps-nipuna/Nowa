import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class Gallery {
  Gallery({
    required this.id,
    required this.name,
    this.description,
    this.coverImageUrl,
    this.photoCount,
    this.createdAt,
    this.likeCount,
  });

  factory Gallery.fromJson(Map<String, dynamic> json) {
    return Gallery(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      coverImageUrl: json['cover_image_url'] as String?,
      photoCount: json['photo_count'] as int?,
      createdAt: json['created_at'] as String?,
      likeCount: json['like_count'] as int?,
    );
  }

  final int id;

  final String name;

  final String? description;

  final String? coverImageUrl;

  final int? photoCount;

  final String? createdAt;

  final int? likeCount;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cover_image_url': coverImageUrl,
      'photo_count': photoCount,
      'created_at': createdAt,
      'like_count': likeCount,
    };
  }
}
