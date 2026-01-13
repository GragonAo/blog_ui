import 'package:blog_ui/models/articles/article_model.dart';
import 'package:blog_ui/widgets/advanced_markdown_body.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'comment_section.dart';

import 'comment_section.dart';


/// 移动端文章详情页面布局
class PostDetailMobile extends StatelessWidget {
  final Article article;

  const PostDetailMobile({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 360,
            pinned: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(LucideIcons.arrowLeft, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(LucideIcons.moreHorizontal, color: Colors.black87),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: article.id,
                    child: Image.network(
                      article.coverUrls.isNotEmpty 
                          ? article.coverUrls.first 
                          : 'https://via.placeholder.com/800x450',
                      fit: BoxFit.cover
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 16,
                    right: 16,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(
                            article.author.avatar == null || article.author.avatar!.isEmpty 
                              ? "https://via.placeholder.com/150" 
                              : article.author.avatar!
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                article.author.username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                article.getTimeAgo(),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.22),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white54),
                          ),
                          child: Row(
                            children: [
                              const Icon(LucideIcons.heart, color: Colors.white, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                '${article.likes}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      article.tags.isNotEmpty ? article.tags.first : '无标签',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    article.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, height: 1.3),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Icon(LucideIcons.mapPin, size: 16, color: Colors.black.withOpacity(0.5)),
                      const SizedBox(width: 6),
                      Text(
                        '分享于 ${article.getTimeAgo()}',
                        style: const TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    article.description,
                    style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
                  ),
                  const SizedBox(height: 14),
                  AdvancedMarkdownBody(
                    data: article.content,
                  ),
                  const SizedBox(height: 26),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StatChip(icon: LucideIcons.heart, label: '喜欢', value: article.likes.toString()),
                      const StatChip(icon: LucideIcons.messageCircle, label: '评论', value: '183'),
                      const StatChip(icon: LucideIcons.share2, label: '分享', value: '收藏'),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: const [
                        Icon(LucideIcons.info, size: 18, color: Colors.black54),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '提示:这只是静态示例数据,你可以接入后端或本地缓存替换这里的展示内容。',
                            style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),                  const SizedBox(height: 30),
                  // 评论区
                  const CommentSection(isDesktop: false),                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(LucideIcons.heart, color: Colors.white, size: 18),
                  label: const Text('喜欢', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(LucideIcons.bookmarkPlus, color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 移动端统计芯片组件
class StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const StatChip({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.black.withOpacity(0.7)),
          const SizedBox(width: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }
}
