import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lucide_icons/lucide_icons.dart';

// 确保这些导入路径在你的项目中是正确的
import '../models/post_model.dart';
import '../widgets/blog_card.dart';
import 'create_post_page.dart';
import 'discover_page.dart';
import 'notifications_page.dart';
import 'post_detail_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String _demoContent = r'''
# Flutter 瀑布流 + 小红书风格
> 这是一篇示例文章，演示 Markdown 里的代码块、公式、列表和引用。
''';

  final List<Post> _posts = const [
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

  final List<String> _tabs = const ['推荐', '科技', '旅行', '美食', '生活'];
  int _activeTab = 0;
  int _activeNav = 0;
  final List<String> _titles = const ['探索动态', '发现', '消息', '我'];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final isFeed = _activeNav == 0;

    if (isDesktop) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: Row(
          children: [
            _DesktopSideNav(
              activeIndex: _activeNav,
              onSelect: (index) => setState(() => _activeNav = index),
            ),
            Expanded(
              child: _buildDesktopBody(),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      extendBodyBehindAppBar: isFeed,
      appBar: _buildGlassAppBar(_titles[_activeNav], isFeed),
      body: _buildMobileBody(),
      floatingActionButton: isFeed ? _buildFab() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildMobileBody() {
    switch (_activeNav) {
      case 0: return _buildMobileFeedBody();
      case 1: return const DiscoverPage();
      case 2: return const NotificationsPage();
      case 3: return const ProfilePage();
      default: return _buildMobileFeedBody();
    }
  }

  Widget _buildDesktopBody() {
    switch (_activeNav) {
      case 0: return _buildDesktopFeed();
      case 1: return const DiscoverPage();
      case 2: return const NotificationsPage();
      case 3: return const ProfilePage();
      default: return _buildDesktopFeed();
    }
  }

  PreferredSizeWidget _buildGlassAppBar(String title, bool overlay) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(68),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: AppBar(
            elevation: 0,
            backgroundColor: overlay ? Colors.white.withOpacity(0.82) : Colors.white,
            leading: IconButton(
              icon: const Icon(LucideIcons.menu, color: Colors.black87),
              onPressed: () {},
            ),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.black87, fontSize: 18)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(LucideIcons.search, color: Colors.black87),
                onPressed: () {},
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileFeedBody() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeader()),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childCount: _posts.length,
            itemBuilder: (context, index) {
              final post = _posts[index];
              return BlogCard(
                post: post,
                index: index,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PostDetailPage(post: post)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  // PC端瀑布流布局 - 参考小红书PC样式
  Widget _buildDesktopFeed() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: CustomScrollView(
          slivers: [
            // PC端顶部导航和搜索
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                child: Column(
                  children: [
                    _buildDesktopSearchBar(),
                    const SizedBox(height: 20),
                    _buildDesktopTabs(),
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
                childCount: _posts.length,
                itemBuilder: (context, index) {
                  final post = _posts[index];
                  return _DesktopBlogCard(
                    post: post,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PostDetailPage(post: post)),
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
  
  Widget _buildDesktopSearchBar() {
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
            icon: const Icon(LucideIcons.camera, color: Colors.black54, size: 22),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
  
  Widget _buildDesktopTabs() {
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 110, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('灵感笔记', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Row(
        children: const [
          Icon(LucideIcons.search, color: Colors.black54, size: 20),
          SizedBox(width: 8),
          Expanded(child: Text('搜索你想看的灵感', style: TextStyle(color: Colors.black54, fontSize: 14))),
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
                border: Border.all(color: active ? Colors.black : Colors.black.withOpacity(0.08)),
              ),
              child: Center(
                child: Text(
                  _tabs[index],
                  style: TextStyle(color: active ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFab() {
    return Container(
      height: 60, width: 60,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)]),
      ),
      child: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.transparent,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreatePostPage()),
        ),
        child: const Icon(LucideIcons.plus, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomAppBar(
      elevation: 20,
      height: 70,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: LucideIcons.home, label: '首页', active: _activeNav == 0, onTap: () => setState(() => _activeNav = 0)),
          _NavItem(icon: LucideIcons.compass, label: '发现', active: _activeNav == 1, onTap: () => setState(() => _activeNav = 1)),
          const SizedBox(width: 48),
          _NavItem(icon: LucideIcons.messageSquare, label: '消息', active: _activeNav == 2, onTap: () => setState(() => _activeNav = 2)),
          _NavItem(icon: LucideIcons.user, label: '我', active: _activeNav == 3, onTap: () => setState(() => _activeNav = 3)),
        ],
      ),
    );
  }
}

// PC端侧边导航
class _DesktopSideNav extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onSelect;

  const _DesktopSideNav({required this.activeIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    const navItems = [
      _SideNavItemData(LucideIcons.home, '首页'),
      _SideNavItemData(LucideIcons.compass, '发现'),
      _SideNavItemData(LucideIcons.messageSquare, '消息'),
      _SideNavItemData(LucideIcons.user, '我'),
    ];

    return Container(
      width: 220,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(1, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '灵感笔记',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.5),
          ),
          const SizedBox(height: 24),
          ...navItems.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            final active = index == activeIndex;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: _DesktopNavItem(
                icon: data.icon,
                label: data.label,
                active: active,
                onTap: () => onSelect(index),
              ),
            );
          }),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreatePostPage()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(LucideIcons.plus, size: 18),
              label: const Text('发布', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SideNavItemData {
  final IconData icon;
  final String label;
  const _SideNavItemData(this.icon, this.label);
}

class _DesktopNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _DesktopNavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: active ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: active ? Colors.white : Colors.black87),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// PC端博客卡片
class _DesktopBlogCard extends StatefulWidget {
  final Post post;
  final VoidCallback onTap;

  const _DesktopBlogCard({required this.post, required this.onTap});

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
                    aspectRatio: 3 / 4,
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
                            backgroundImage: NetworkImage(widget.post.authorAvatar),
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

// 独立的组件类，放在主类外部
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: active ? Colors.redAccent : Colors.black45),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: active ? Colors.redAccent : Colors.black45)),
        ],
      ),
    );
  }
}