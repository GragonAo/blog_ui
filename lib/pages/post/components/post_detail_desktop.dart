import 'package:blog_ui/models/articles/article_model.dart';
import 'package:blog_ui/widgets/advanced_markdown_body.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'comment_section.dart';

/// PC端文章详情页面布局
class PostDetailDesktop extends StatelessWidget {
  final Article article;

  const PostDetailDesktop({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '文章详情',
          style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 左侧主内容区
              Expanded(
                flex: 7,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 文章头图
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.network(
                              article.coverUrls.isNotEmpty 
                                  ? article.coverUrls.first 
                                  : 'https://via.placeholder.com/800x450', 
                              fit: BoxFit.cover
                            ),
                          ),
                        ),
                        // 文章内容
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 标签
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  article.tags.isNotEmpty ? article.tags.first : '无标签',
                                  style: TextStyle(
                                    color: Colors.red.shade400,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // 标题
                              Text(
                                article.title,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  height: 1.4,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              // 时间
                              Text(
                                article.getTimeAgo(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const Divider(height: 32),
                              // 描述
                              Text(
                                article.description,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.8,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Markdown内容
                              AdvancedMarkdownBody(data: article.content),
                              const SizedBox(height: 32),
                              // 互动栏
                              Row(
                                children: [
                                  DesktopActionButton(
                                    icon: LucideIcons.heart,
                                    label: '喜欢',
                                    value: article.likes.toString(),
                                  ),
                                  const SizedBox(width: 16),
                                  const DesktopActionButton(
                                    icon: LucideIcons.messageCircle,
                                    label: '评论',
                                    value: '183',
                                  ),
                                  const SizedBox(width: 16),
                                  const DesktopActionButton(
                                    icon: LucideIcons.share2,
                                    label: '分享',
                                    value: '',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // 评论区
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                          child: CommentSection(isDesktop: true),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // 右侧作者信息和推荐栏
              Container(
                width: 320,
                margin: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                child: Column(
                  children: [
                    // 作者卡片
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                                article.author.avatar == null || article.author.avatar!.isEmpty 
                                    ? "https://via.placeholder.com/150" 
                                    : article.author.avatar!
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            article.author.username,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '分享于 ${article.getTimeAgo()}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade400,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                '关注',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const AuthorStat(label: '获赞', value: '12.5k'),
                              Container(
                                width: 1,
                                height: 20,
                                color: Colors.grey.shade300,
                              ),
                              const AuthorStat(label: '粉丝', value: '8.2k'),
                              Container(
                                width: 1,
                                height: 20,
                                color: Colors.grey.shade300,
                              ),
                              const AuthorStat(label: '获藏', value: '6.3k'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 推荐阅读
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '推荐阅读',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 16),
                          RecommendItem(
                            title: 'Flutter 性能优化实战指南',
                            views: '2.3k',
                          ),
                          Divider(height: 20),
                          RecommendItem(
                            title: '用 Dart 构建高效的后端服务',
                            views: '1.8k',
                          ),
                          Divider(height: 20),
                          RecommendItem(
                            title: '从零开始学习 Flutter 动画',
                            views: '3.1k',
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

/// PC端操作按钮组件
class DesktopActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DesktopActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade100,
        foregroundColor: Colors.black87,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(
            value.isEmpty ? label : '$label $value',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/// 作者统计组件
class AuthorStat extends StatelessWidget {
  final String label;
  final String value;

  const AuthorStat({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

/// 推荐文章项组件
class RecommendItem extends StatelessWidget {
  final String title;
  final String views;

  const RecommendItem({super.key, required this.title, required this.views});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(LucideIcons.eye, size: 12, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text(
                views,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
