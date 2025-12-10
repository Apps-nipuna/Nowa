import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:orsa_3/components/side_menu.dart';
import 'package:orsa_3/pages/article_details.dart';

@NowaGenerated()
class HomePage extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

@NowaGenerated()
class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> allArticles = [];

  List<Map<String, dynamic>> filteredArticles = [];

  List<Map<String, dynamic>> topArticles = [];

  String selectedCategory = 'All';

  bool isLoading = true;

  List<String> categories = ['All'];

  void _processArticles() {
    Set<String> uniqueCategories = {'All'};
    for (var article in allArticles) {
      if (article['category'] != null) {
        uniqueCategories.add(article['category']);
      }
    }
    categories = uniqueCategories.toList();
    topArticles = List.from(allArticles)
      ..sort((a, b) {
        int aScore = (a['like_count'] ?? 0) + (a['comment_count'] ?? 0);
        int bScore = (b['like_count'] ?? 0) + (b['comment_count'] ?? 0);
        return bScore.compareTo(aScore);
      });
    topArticles = topArticles.take(7).toList();
    _filterArticles();
  }

  Widget _buildCategoryFilter(ColorScheme colorScheme, TextTheme textTheme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: categories
            .map(
              (category) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                      _filterArticles();
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        category,
                        style: textTheme.bodyMedium?.copyWith(
                          color: selectedCategory == category
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                          fontWeight: selectedCategory == category
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      if (selectedCategory == category)
                        Container(
                          height: 3,
                          width: 30,
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> _fetchArticles() async {
    try {
      final response = await Supabase.instance.client
          .from('articles')
          .select('*, likes(id), comments(id)')
          .order('created_at', ascending: false);
      if (mounted) {
        setState(() {
          allArticles = List<Map<String, dynamic>>.from(response).map((
            article,
          ) {
            final likes = article['likes'] as List? ?? [];
            final comments = article['comments'] as List? ?? [];
            article['like_count'] = likes.length;
            article['comment_count'] = comments.length;
            article.remove('likes');
            article.remove('comments');
            return article;
          }).toList();
          _processArticles();
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching articles: ${e}');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load articles: ${e}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _filterArticles() {
    if (selectedCategory == 'All') {
      filteredArticles = (allArticles.cast<Map<String, dynamic>>())
          .take(15)
          .toList();
    } else {
      filteredArticles = allArticles
          .where((article) => article['category'] == selectedCategory)
          .toList()
          .take(15)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      drawer: const SideMenu(),
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: colorScheme.onPrimary),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          'ORSA',
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: colorScheme.onPrimary,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.help_outline, color: colorScheme.onPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (allArticles.isNotEmpty)
                    _buildLatestArticleCover(colorScheme, textTheme),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Top News',
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (topArticles.isNotEmpty)
                    _buildTopArticlesHorizontal(colorScheme, textTheme),
                  const SizedBox(height: 24),
                  _buildCategoryFilter(colorScheme, textTheme),
                  const SizedBox(height: 16),
                  _buildArticlesList(colorScheme, textTheme),
                ],
              ),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    print('HomePage initState called');
    _fetchArticles();
  }

  Widget _buildLatestArticleCover(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    if (allArticles.isEmpty) {
      return const SizedBox.shrink();
    }
    final article = allArticles.first;
    final imageUrl = article['image_url'] as String?;
    final title = article['title'] as String?;
    final category = article['category'] as String?;
    final articleId = article['id'] as int?;
    return GestureDetector(
      onTap: () {
        if (articleId != null) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: true,
            builder: (context) => ArticleDetails(articleId: articleId!),
          );
        }
      },
      child: Stack(
        children: [
          Container(
            height: 280,
            width: double.infinity,
            decoration: BoxDecoration(
              image: imageUrl != null && imageUrl!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
              color: colorScheme.primaryContainer,
            ),
          ),
          Container(
            height: 280,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.8),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (category != null && category!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category!,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  title ?? 'No Title',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopArticlesHorizontal(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: topArticles.length,
        itemBuilder: (context, index) {
          final article = topArticles[index];
          final imageUrl = article['image_url'] as String?;
          final title = article['title'] as String?;
          final articleId = article['id'] as int?;
          int engagement =
              (article['like_count'] as int? ?? 0) +
              (article['comment_count'] as int? ?? 0);
          return GestureDetector(
            onTap: () {
              if (articleId != null) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  isDismissible: true,
                  builder: (context) => ArticleDetails(articleId: articleId!),
                );
              }
            },
            child: Container(
              width: 160,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: imageUrl != null && imageUrl!.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(imageUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: colorScheme.primaryContainer,
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    size: 14,
                                    color: colorScheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    engagement.toString(),
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title ?? 'No Title',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildArticlesList(ColorScheme colorScheme, TextTheme textTheme) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: filteredArticles.length,
      itemBuilder: (context, index) {
        final article = filteredArticles[index];
        final likeCount = article['like_count'] as int? ?? 0;
        final commentCount = article['comment_count'] as int? ?? 0;
        final imageUrl = article['image_url'] as String?;
        final title = article['title'] as String?;
        final createdAtStr = article['created_at'] as String?;
        final articleId = article['id'] as int?;
        String timeAgo = 'just now';
        if (createdAtStr != null && createdAtStr!.isNotEmpty) {
          try {
            final createdAt = DateTime.parse(createdAtStr!);
            final now = DateTime.now();
            final difference = now.difference(createdAt);
            if (difference.inMinutes < 60) {
              timeAgo = '${difference.inMinutes}m';
            } else {
              if (difference.inHours < 24) {
                timeAgo = '${difference.inHours}h';
              } else {
                timeAgo = '${difference.inDays}d';
              }
            }
          } catch (e) {
            timeAgo = 'recently';
          }
        }
        return GestureDetector(
          onTap: () {
            if (articleId != null) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                isDismissible: true,
                builder: (context) => ArticleDetails(articleId: articleId!),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.1),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Row(
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      image: imageUrl != null && imageUrl!.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title ?? 'No Title',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                timeAgo,
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.favorite,
                                size: 14,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                likeCount.toString(),
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.comment_outlined,
                                size: 14,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                commentCount.toString(),
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
