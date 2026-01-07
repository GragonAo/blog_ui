import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:blog_ui/models/post_model.dart';
import 'package:blog_ui/pages/post/post_detail_page.dart';

/// 桌面端首页
class DesktopHome extends StatefulWidget {
  final List<Post> posts;

  const DesktopHome({
    super.key,
    required this.posts,
  });

  @override
  State<DesktopHome> createState() => _DesktopHomeState();
}

class _DesktopHomeState extends State<DesktopHome> {
  final List<String> _tabs = const ['模拟人生', '科技', '旅行', '美食', '生活'];
  int _activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: CustomScrollView(
          slivers: [
            // 顶部导航和搜索
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                child: Column(
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 20),
                    _buildTabs(),
                  ],
                ),
              ),
            ),
            // 瀑布流网格
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
              sliver: SliverMasonryGrid.count(
                crossAxisCount: 5, // PC端显示5列
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childCount: widget.posts.length,
                itemBuilder: (context, index) {
                  final post = widget.posts[index];
                  return _DesktopBlogCard(
                    post: post,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PostDetailPage(post: post),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.search, color: Colors.black54, size: 22),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              '搜索你想看的灵感...',
              style: TextStyle(color: Colors.black45, fontSize: 15),
            ),
          ),
          IconButton(
            icon:
                const Icon(LucideIcons.camera, color: Colors.black54, size: 22),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _tabs.asMap().entries.map((entry) {
        final index = entry.key;
        final tab = entry.value;
        final active = index == _activeTab;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GestureDetector(
            onTap: () => setState(() => _activeTab = index),
            child: AnimatedContainer(
              duration: 200.ms,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: active ? Colors.black : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active ? Colors.black : Colors.grey.shade300,
                ),
              ),
              child: Text(
                tab,
                style: TextStyle(
                  color: active ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ==================== 桌面端博客卡片 ====================

class _DesktopBlogCard extends StatefulWidget {
  final Post post;
  final VoidCallback onTap;

  const _DesktopBlogCard({
    required this.post,
    required this.onTap,
  });

  @override
  State<_DesktopBlogCard> createState() => _DesktopBlogCardState();
}

class _DesktopBlogCardState extends State<_DesktopBlogCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _isHovered ? -8 : 0, 0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_isHovered ? 0.12 : 0.06),
                  blurRadius: _isHovered ? 20 : 12,
                  offset: Offset(0, _isHovered ? 8 : 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 图片
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.network(
                      widget.post.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // 内容
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundImage:
                                NetworkImage(widget.post.authorAvatar),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              widget.post.author,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            LucideIcons.heart,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.post.likes > 1000
                                ? '${(widget.post.likes / 1000).toStringAsFixed(1)}k'
                                : '${widget.post.likes}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
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
        ),
      ),
    );
  }
}
