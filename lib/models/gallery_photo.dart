import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class GalleryPhoto {
  GalleryPhoto({
    required this.id,
    required this.galleryId,
    required this.photoUrl,
    this.caption,
  });

  factory GalleryPhoto.fromJson(Map<String, dynamic> json) {
    String photoUrl = '';
    final possibleKeys = [
      'photo_url',
      'photoUrl',
      'image_url',
      'imageUrl',
      'url',
      'image',
      'photo',
    ];
    for (String key in possibleKeys) {
      if (json.containsKey(key) && json[key] != null) {
        final value = json[key];
        if (value is String && value.isNotEmpty) {
          photoUrl = value;
          print('🎨 GalleryPhoto: Found URL in "${key}": ${photoUrl}');
          break;
        }
      }
    }
    if (photoUrl.isEmpty) {
      final id = json['id'];
      if (id != null) {
        photoUrl = 'photo_${id}';
      }
    }
    return GalleryPhoto(
      id: (json['id'] ?? 0) as int,
      galleryId: (json['gallery_id'] ?? json['galleryId'] ?? 0) as int,
      photoUrl: photoUrl,
      caption: json['caption'] as String?,
    );
  }

  final int id;

  final int galleryId;

  final String photoUrl;

  final String? caption;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gallery_id': galleryId,
      'photo_url': photoUrl,
      'caption': caption,
    };
  }
}
