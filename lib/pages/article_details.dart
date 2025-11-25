import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@NowaGenerated()
class ArticleDetails extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const ArticleDetails({required this.articleId, super.key});

  final int articleId;

  @override
  State<ArticleDetails> createState() {
    return _ArticleDetailsState();
  }
}

@NowaGenerated()
class _ArticleDetailsState extends State<ArticleDetails> {
  Map<String, dynamic>? article;

  List<Map<String, dynamic>> comments = [];

  int likeCount = 0;

  bool isLiked = false;

  bool isLoading = true;

  Future<void> _toggleLike() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please sign in to like articles')),
        );
        return;
      }
      if (isLiked) {
        await Supabase.instance.client
            .from('likes')
            .delete()
            .eq('article_id', widget.articleId)
            .eq('user_id', userId);
        if (mounted) {
          setState(() {
            isLiked = false;
            likeCount--;
          });
        }
      } else {
        await Supabase.instance.client.from('likes').insert({
          'article_id': widget.articleId,
          'user_id': userId,
        });
        if (mounted) {
          setState(() {
            isLiked = true;
            likeCount++;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e}')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final article = await Supabase.instance.client
          .from('articles')
          .select('*')
          .eq('id', widget.articleId)
          .single();
      final comments = await Supabase.instance.client
          .from('comments')
          .select('*, profiles(common_name, avatar_url)')
          .eq('article_id', widget.articleId)
          .order('created_at', ascending: false);
      final likes = await Supabase.instance.client
          .from('likes')
          .select('id')
          .eq('article_id', widget.articleId);
      bool userLiked = false;
      if (userId != null) {
        final userLike = await Supabase.instance.client
            .from('likes')
            .select('id')
            .eq('article_id', widget.articleId)
            .eq('user_id', userId);
        userLiked = userLike.isNotEmpty;
      }
      if (mounted) {
        setState(() {
          this.article = article;
          this.comments = List<Map<String, dynamic>>.from(comments);
          likeCount = likes.length;
          isLiked = userLiked;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorScheme.onPrimary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'විපසරණ',
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(colorScheme.primary),
              ),
            )
          : (((article == null
                ? const Center(child: Text('Not found'))
                : (((SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 280,
                          width: double.infinity,
                          color: colorScheme.primaryContainer,
                          child: article?['image_url'] != null
                              ? Image.network(
                                  article!['image_url'],
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    size: 16,
                                    color: colorScheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${likeCount}',
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '3h',
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                article?['title'] ?? '',
                                style: textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                article?['content'] ?? '',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Divider(color: colorScheme.outline),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: _toggleLike,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            isLiked
                                                ? Icons.thumb_up
                                                : Icons.thumb_up_outlined,
                                            size: 20,
                                            color: isLiked
                                                ? colorScheme.primary
                                                : colorScheme.onSurfaceVariant,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Like',
                                            style: textTheme.bodyMedium
                                                ?.copyWith(
                                                  color: isLiked
                                                      ? colorScheme.primary
                                                      : colorScheme
                                                            .onSurfaceVariant,
                                                  fontWeight: isLiked
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.comment_outlined,
                                          size: 20,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Comment',
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.share_outlined,
                                          size: 20,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Share',
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Divider(color: colorScheme.outline),
                              const SizedBox(height: 16),
                              Text(
                                'Comments (${comments.length})',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ...comments.map((c) {
                                final profile = c['profiles'] ?? {};
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor:
                                            colorScheme.primaryContainer,
                                        child: Icon(
                                          Icons.person,
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              profile['common_name'] ?? 'User',
                                              style: textTheme.bodyMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        colorScheme.onSurface,
                                                  ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              c['content'] ?? '',
                                              style: textTheme.bodySmall
                                                  ?.copyWith(
                                                    color:
                                                        colorScheme.onSurface,
                                                  ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Text(
                                                  '3h',
                                                  style: textTheme.labelSmall
                                                      ?.copyWith(
                                                        color: colorScheme
                                                            .onSurfaceVariant,
                                                      ),
                                                ),
                                                const SizedBox(width: 16),
                                                Text(
                                                  'Like',
                                                  style: textTheme.labelSmall
                                                      ?.copyWith(
                                                        color: colorScheme
                                                            .onSurfaceVariant,
                                                      ),
                                                ),
                                                const SizedBox(width: 16),
                                                Text(
                                                  'Reply',
                                                  style: textTheme.labelSmall
                                                      ?.copyWith(
                                                        color: colorScheme
                                                            .onSurfaceVariant,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))))))),
    );
  }
}
