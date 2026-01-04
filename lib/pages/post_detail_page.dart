import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../models/post_model.dart';
import '../widgets/advanced_markdown_body.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;

  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    if (isDesktop) {
      return _buildDesktopLayout(context);
    } else {
      return _buildMobileLayout(context);
    }
  }

  // PC端布局 - 参考小红书PC样式
  Widget _buildDesktopLayout(BuildContext context) {
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
                            child: Image.network(post.imageUrl, fit: BoxFit.cover),
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
                                  post.tag,
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
                                post.title,
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
                                post.timeAgo,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const Divider(height: 32),
                              // 描述
                              Text(
                                post.description,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.8,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Markdown内容
                              AdvancedMarkdownBody(data: post.content),
                              const SizedBox(height: 32),
                              // 互动栏
                              Row(
                                children: [
                                  _DesktopActionButton(
                                    icon: LucideIcons.heart,
                                    label: '喜欢',
                                    value: post.likes.toString(),
                                  ),
                                  const SizedBox(width: 16),
                                  _DesktopActionButton(
                                    icon: LucideIcons.messageCircle,
                                    label: '评论',
                                    value: '183',
                                  ),
                                  const SizedBox(width: 16),
                                  _DesktopActionButton(
                                    icon: LucideIcons.share2,
                                    label: '分享',
                                    value: '',
                                  ),
                                ],
                              ),
                            ],
                          ),
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
                            backgroundImage: NetworkImage(post.authorAvatar),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            post.author,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '分享于 ${post.timeAgo}',
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
                              _AuthorStat(label: '获赞', value: '12.5k'),
                              Container(
                                width: 1,
                                height: 20,
                                color: Colors.grey.shade300,
                              ),
                              _AuthorStat(label: '粉丝', value: '8.2k'),
                              Container(
                                width: 1,
                                height: 20,
                                color: Colors.grey.shade300,
                              ),
                              _AuthorStat(label: '获藏', value: '6.3k'),
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
                        children: [
                          const Text(
                            '推荐阅读',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _RecommendItem(
                            title: 'Flutter 性能优化实战指南',
                            views: '2.3k',
                          ),
                          const Divider(height: 20),
                          _RecommendItem(
                            title: '用 Dart 构建高效的后端服务',
                            views: '1.8k',
                          ),
                          const Divider(height: 20),
                          _RecommendItem(
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

  // 移动端布局 - 原有样式
  Widget _buildMobileLayout(BuildContext context) {
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
                    tag: post.id,
                    child: Image.network(post.imageUrl, fit: BoxFit.cover),
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
                        CircleAvatar(radius: 22, backgroundImage: NetworkImage(post.authorAvatar)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                post.author,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(post.timeAgo, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12)),
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
                              Text('${post.likes}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
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
                      post.tag,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    post.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, height: 1.3),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Icon(LucideIcons.mapPin, size: 16, color: Colors.black.withOpacity(0.5)),
                      const SizedBox(width: 6),
                      Text('分享于 ${post.timeAgo}', style: const TextStyle(fontSize: 13, color: Colors.black54)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    post.description,
                    style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
                  ),
                  const SizedBox(height: 14),
                  AdvancedMarkdownBody(
                    data: post.content,
                  ),
                  const SizedBox(height: 26),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatChip(icon: LucideIcons.heart, label: '喜欢', value: post.likes.toString()),
                      _StatChip(icon: LucideIcons.messageCircle, label: '评论', value: '183'),
                      _StatChip(icon: LucideIcons.share2, label: '分享', value: '收藏'),
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
                            '提示：这只是静态示例数据，你可以接入后端或本地缓存替换这里的展示内容。',
                            style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
              BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, -4)),
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

// 移动端统计芯片
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatChip({required this.icon, required this.label, required this.value});

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

// PC端操作按钮
class _DesktopActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DesktopActionButton({
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

// 作者统计
class _AuthorStat extends StatelessWidget {
  final String label;
  final String value;

  const _AuthorStat({required this.label, required this.value});

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

// 推荐项
class _RecommendItem extends StatelessWidget {
  final String title;
  final String views;

  const _RecommendItem({required this.title, required this.views});

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
