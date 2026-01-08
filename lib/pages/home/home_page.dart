import 'package:flutter/material.dart';
import 'package:blog_ui/models/post_model.dart';
import 'package:blog_ui/widgets/blog_card.dart';
import 'package:blog_ui/pages/post/post_detail_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// 首页 - 响应式布局
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _activeTab = 0;

  static const String _demoContent = r'''
# Flutter 瀑布流 + 小红书风格
> 这是一篇示例文章，演示 Markdown 里的代码块、公式、列表和引用。
''';

  static const List<Post> _posts = [
    Post(
      id: 'p1',
      title: '在京都街头拍下一缕傍晚光影，温柔到不舍得离开',
      author: '椿小九',
      authorAvatar: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=200&q=80',
      imageUrl: 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=900&q=80',
      tag: '旅行日记',
      timeAgo: '2 小时前',
      likes: 2480,
      description: '黄昏下的京都，木质町屋和灯笼的味道。',
      imageHeight: 240,
      content: _demoContent,
    ),
    Post(
      id: 'p2',
      title: '用 Flutter 打造毛玻璃质感的首页，细节拆解',
      author: '开发者 Gragon',
      authorAvatar: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=200&q=80',
      imageUrl: 'https://images.unsplash.com/photo-1523475472560-d2df97ec485c?auto=format&fit=crop&w=900&q=80',
      tag: '技术灵感',
      timeAgo: '5 小时前',
      likes: 1864,
      description: '复刻小红书卡片的瀑布流细节。',
      imageHeight: 200,
      content: _demoContent,
    ),
    // ... 可以根据需要继续添加 Post 数据
  ];

  static const List<String> _categories = [
    '模拟人生',
    '科技',
    '旅行',
    '美食',
    '生活',
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;
    final crossAxisCount = isDesktop ? 5 : 2;
    final horizontalPadding = isDesktop ? 40.0 : 12.0;
    final spacing = isDesktop ? 20.0 : 14.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isDesktop ? 1400 : double.infinity),
          child: CustomScrollView(
            slivers: [
              // 顶部区域
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    isDesktop ? 24 : 25,
                    horizontalPadding,
                    isDesktop ? 0 : 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchBar(isDesktop),
                      SizedBox(height: isDesktop ? 20 : 14),
                      _buildTabs(isDesktop),
                      SizedBox(height: isDesktop ? 24 : 10),
                    ],
                  ),
                ),
              ),
              // 瀑布流网格
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  0,
                  horizontalPadding,
                  isDesktop ? 40 : 20,
                ),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: spacing,
                  crossAxisSpacing: spacing,
                  childCount: _posts.length,
                  itemBuilder: (context, index) {
                    final post = _posts[index];
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
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 20 : 14,
        vertical: isDesktop ? 14 : 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isDesktop ? 24 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDesktop ? 0.06 : 0.04),
            blurRadius: isDesktop ? 16 : 12,
            offset: Offset(0, isDesktop ? 4 : 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.search,
            color: Colors.black54,
            size: isDesktop ? 22 : 20,
          ),
          SizedBox(width: isDesktop ? 12 : 8),
          Expanded(
            child: Text(
              isDesktop ? '搜索你想看的灵感...' : '搜索你想看的灵感',
              style: TextStyle(
                color: isDesktop ? Colors.black45 : Colors.black54,
                fontSize: isDesktop ? 15 : 14,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              LucideIcons.camera,
              color: Colors.black54,
              size: isDesktop ? 22 : 20,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(bool isDesktop) {
    if (isDesktop) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _categories.asMap().entries.map((entry) {
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

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
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
                  _categories[index],
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

