import 'package:flutter/material.dart';
import 'package:orsa_3/models/gallery.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@NowaGenerated()
class MemoriesHome extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const MemoriesHome({super.key});

  @override
  State<MemoriesHome> createState() {
    return _MemoriesHomeState();
  }
}

@NowaGenerated()
class _MemoriesHomeState extends State<MemoriesHome> {
  late Future<List<Gallery>> galleriesFuture;

  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadGalleries();
  }

  void _loadGalleries() {
    galleriesFuture = _fetchGalleries();
  }

  Future<List<Gallery>> _fetchGalleries() async {
    final response = await Supabase.instance.client.from('galleries').select();
    final galleries = (response as List)
        .map((e) => Gallery.fromJson(e as Map<String, dynamic>))
        .toList();
    galleries.sort((a, b) {
      if (a.createdAt == null || b.createdAt == null) {
        return 0;
      }
      return DateTime.parse(
        b.createdAt!,
      ).compareTo(DateTime.parse(a.createdAt!));
    });
    return galleries;
  }

  List<Gallery> _filterGalleries(List<Gallery> galleries) {
    if (searchQuery.isEmpty) {
      return galleries;
    }
    final query = searchQuery.toLowerCase();
    return galleries
        .where(
          (gallery) =>
              gallery.name.toLowerCase().contains(query) ||
              (gallery.description?.toLowerCase().contains(query) ?? false),
        )
        .toList();
  }

  String _getTimeAgo(String? createdAt) {
    if (createdAt == null) {
      return 'Recently';
    }
    try {
      final createdDate = DateTime.parse(createdAt!);
      final now = DateTime.now();
      final difference = now.difference(createdDate);
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '${years} year${years > 1 ? 's' : ''} ago';
      } else {
        if (difference.inDays > 30) {
          final months = (difference.inDays / 30).floor();
          return '${months} month${months > 1 ? 's' : ''} ago';
        } else {
          if (difference.inDays > 0) {
            return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
          } else {
            if (difference.inHours > 0) {
              return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
            } else {
              if (difference.inMinutes > 0) {
                return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
              } else {
                return 'Just now';
              }
            }
          }
        }
      }
    } catch (e) {
      return 'Recently';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Memories',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search galleries...',
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Gallery>>(
                future: galleriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('No galleries found'),
                    );
                  }
                  final filteredGalleries = _filterGalleries(snapshot.data!);
                  if (filteredGalleries.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('No galleries match your search'),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: filteredGalleries.length,
                    itemBuilder: (context, index) {
                      final gallery = filteredGalleries[index];
                      return _GalleryCard(
                        gallery: gallery,
                        timeAgo: _getTimeAgo(gallery.createdAt),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@NowaGenerated()
class _GalleryCard extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const _GalleryCard({required this.gallery, required this.timeAgo, super.key});

  final Gallery gallery;

  final String timeAgo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (gallery.coverImageUrl != null)
                Container(
                  width: double.infinity,
                  height: 200,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Image.network(
                    gallery.coverImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(
                        Icons.image_not_supported,
                        color: Theme.of(context).colorScheme.primary,
                        size: 48,
                      ),
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  height: 200,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.image,
                    color: Theme.of(context).colorScheme.primary,
                    size: 48,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            gallery.name,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          timeAgo,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                    if (gallery.description != null &&
                        gallery.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          gallery.description!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.collections,
                                size: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${gallery.photoCount ?? 0} photos',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.favorite,
                                size: 18,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${gallery.likeCount ?? 0} likes',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
