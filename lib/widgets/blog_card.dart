import 'package:blog_ui/models/articles/article_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BlogCard extends StatelessWidget {
  final Article article;
  final int index;
  final VoidCallback onTap;

  const BlogCard({super.key, required this.article, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: Stack(
                children: [
                  Hero(
                    tag: article.id,
                    child: Image.network(
                      article.coverUrls.isNotEmpty ? article.coverUrls[0] : 'https://via.placeholder.com/800x450',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.35),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.image, color: Colors.white, size: 14),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black54],
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(LucideIcons.heart, size: 14, color: Colors.white.withOpacity(0.9)),
                          const SizedBox(width: 4),
                          Text('${article.likes}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                          const Spacer(),
                          Icon(LucideIcons.clock, size: 14, color: Colors.white.withOpacity(0.85)),
                          const SizedBox(width: 4),
                          Text(article.getTimeAgo(), style: const TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      article.tags.isNotEmpty ? article.tags.first : '无标签',
                       style: TextStyle(color: theme.colorScheme.primary, fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, height: 1.4),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundImage: NetworkImage(
                            article.author.avatar == null || article.author.avatar!.isEmpty ? "https://via.placeholder.com/150" : article.author.avatar!),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          article.author.username,
                          style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Icon(LucideIcons.moreHorizontal, size: 18, color: Colors.black38),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 400.ms, delay: (index * 40).ms)
          .moveY(begin: 12, end: 0, curve: Curves.easeOut));
  }
}
