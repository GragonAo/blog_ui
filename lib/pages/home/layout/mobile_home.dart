import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:blog_ui/models/post_model.dart';
import 'package:blog_ui/widgets/blog_card.dart';
import 'package:blog_ui/pages/post/post_detail_page.dart';

/// 移动端首页
class MobileHome extends StatefulWidget {
  final List<Post> posts;

  const MobileHome({
    super.key,
    required this.posts,
  });

  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
  final List<String> _tabs = const ['模拟人生', '科技', '旅行', '美食', '生活'];
  int _activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      extendBodyBehindAppBar: true,
      appBar: _buildGlassAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildGlassAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(68),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.white.withOpacity(0.82),
            leading: IconButton(
              icon: const Icon(LucideIcons.menu, color: Colors.black87),
              onPressed: () {},
            ),
            title: const Text(
              '探索动态',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.black87,
                fontSize: 18,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeader()),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childCount: widget.posts.length,
            itemBuilder: (context, index) {
              final post = widget.posts[index];
              return BlogCard(
                post: post,
                index: index,
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
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 110, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SulSul博客',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildSearchBar(),
          const SizedBox(height: 14),
          _buildTabList(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: const [
          Icon(LucideIcons.search, color: Colors.black54, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              '搜索你想看的灵感',
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ),
          Icon(LucideIcons.camera, color: Colors.black54, size: 20),
        ],
      ),
    );
  }

  Widget _buildTabList() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final active = index == _activeTab;
          return GestureDetector(
            onTap: () => setState(() => _activeTab = index),
            child: AnimatedContainer(
              duration: 200.ms,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: active ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active ? Colors.black : Colors.black.withOpacity(0.08),
                ),
              ),
              child: Center(
                child: Text(
                  _tabs[index],
                  style: TextStyle(
                    color: active ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
