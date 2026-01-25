import 'package:flutter/material.dart';
import 'package:orsa_3/models/gallery_photo.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:orsa_3/functions/sanitize_image_url.dart';
import 'package:orsa_3/models/gallery.dart';

@NowaGenerated()
class GalleryCarousel extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const GalleryCarousel({required this.gallery, super.key});

  final Gallery gallery;

  @override
  State<GalleryCarousel> createState() {
    return _GalleryCarouselState();
  }
}

@NowaGenerated()
class _GalleryCarouselState extends State<GalleryCarousel> {
  late Future<List<GalleryPhoto>> photosFuture;

  late PageController pageController;

  int currentIndex = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print(
      '🚀 GalleryCarousel initState - Gallery: name="${widget.gallery.name}", id=${widget.gallery.id}',
    );
    photosFuture = _fetchPhotos();
    pageController = PageController();
  }

  Future<List<GalleryPhoto>> _fetchPhotos() async {
    print('🔍 _fetchPhotos START - Gallery ID: ${widget.gallery.id}');
    try {
      final allPhotos = await Supabase.instance.client
          .from('gallery_photos')
          .select('*')
          .limit(5);
      print('📋 ALL PHOTOS (first 5): ${allPhotos}');
      final rawResponse = await Supabase.instance.client
          .from('gallery_photos')
          .select('*')
          .eq('gallery_id', widget.gallery.id);
      print('📋 FILTERED RESPONSE: ${rawResponse}');
      print('📋 FILTERED RESPONSE TYPE: ${rawResponse.runtimeType}');
      if (rawResponse is List) {
        print('📊 Received List with ${rawResponse.length} items');
        if (rawResponse.isNotEmpty) {
          print('📊 First item FULL DATA: ${rawResponse[0]}');
          print('📊 First item KEYS: ${(rawResponse[0] as Map).keys.toList()}');
        }
        final photos = rawResponse
            .map((e) => GalleryPhoto.fromJson(e as Map<String, dynamic>))
            .toList();
        print('✅ Converted to ${photos.length} GalleryPhoto objects');
        for (int i = 0; i < photos.length; i++) {
          print(
            '   Photo ${i}: id=${photos[i].id}, URL="${photos[i].photoUrl}"',
          );
        }
        return photos;
      } else {
        print('❌ Response not a List: ${rawResponse}');
        return [];
      }
    } catch (e) {
      print('❌ ERROR in _fetchPhotos: ${e}');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.gallery.name),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: FutureBuilder<List<GalleryPhoto>>(
        future: photosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading photos:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No photos in this gallery',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }
          final photos = snapshot.data;
          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemCount: photos?.length,
                  itemBuilder: (context, index) {
                    final photo = photos![index];
                    final imageUrl = sanitizeImageUrl(photo.photoUrl);
                    final displayUrl = imageUrl.isNotEmpty
                        ? imageUrl
                        : 'https://images.unsplash.com/photo-1606933248051-5ce25b3dcd8a?w=600';
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Image.network(
                              displayUrl,
                              fit: BoxFit.contain,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            loadingProgress
                                                    ?.expectedTotalBytes !=
                                                null
                                            ? loadingProgress!
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress!
                                                      .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) =>
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.broken_image,
                                          size: 64,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.error,
                                        ),
                                        const SizedBox(height: 16),
                                        const Text('Image failed to load'),
                                        const SizedBox(height: 8),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                'Photo ID: ${photo.id}',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                              ),
                                              Text(
                                                'Gallery ID: ${photo.galleryId}',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                              ),
                                              if (photo.photoUrl.isNotEmpty)
                                                Text(
                                                  'URL: ${photo.photoUrl}',
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.bodySmall,
                                                )
                                              else
                                                Text(
                                                  'No URL in database',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: Theme.of(
                                                          context,
                                                        ).colorScheme.error,
                                                      ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ),
                          ),
                          if (photo.caption != null &&
                              photo.caption!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                photo.caption!,
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    photos!.length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () {
                          pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          width: currentIndex == index ? 32 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: currentIndex == index
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
