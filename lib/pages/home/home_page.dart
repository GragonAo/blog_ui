import 'package:blog_ui/models/post/post_model.dart';
import 'package:blog_ui/models/user/info.dart';
import 'package:blog_ui/utils/platform/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:blog_ui/widgets/blog_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:get/get.dart';

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

static final List<Post> _posts = [
  Post(
    id: 'p1',
    title: '在京都街头拍下一缕傍晚光影',
    author: UserBaseInfo(
      id: 1,
      username: '椿小九',
      avatar: 'https://images.unsplash.com/...',
    ),
    content: '正文内容...',
    imageUrl: ['https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=900&q=80'],
    tag: '旅行日记',
    summary: '黄昏下的京都，木质町屋和灯笼的味道。',
    status: PostStatus.published,
    likes: 2480,
    viewCount: 5000,
    createdAt: DateTime.now().subtract(Duration(hours: 2)),
    updatedAt: DateTime.now().subtract(Duration(hours: 1)),
  ), Post(
    id: 'p2',
    title: '在京都街头拍下一缕傍晚光影',
    author: UserBaseInfo(
      id: 1,
      username: '椿小九',
      avatar: 'https://images.unsplash.com/...',
    ),
    content: '正文内容...',
    imageUrl: ['https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=900&q=80'],
    tag: '旅行日记',
    summary: '黄昏下的京都，木质町屋和灯笼的味道。',
    status: PostStatus.published,
    likes: 2480,
    viewCount: 5000,
    createdAt: DateTime.now().subtract(Duration(hours: 2)),
    updatedAt: DateTime.now().subtract(Duration(hours: 1)),
  ),
   Post(
    id: 'p3',
    title: '在京都街头拍下一缕傍晚光影',
    author: UserBaseInfo(
      id: 1,
      username: '椿小九',
      avatar: 'https://images.unsplash.com/...',
    ),
    content: '正文内容...',
    imageUrl: ['https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=900&q=80'],
    tag: '旅行日记',
    summary: '黄昏下的京都，木质町屋和灯笼的味道。',
    status: PostStatus.published,
    likes: 2480,
    viewCount: 5000,
    createdAt: DateTime.now().subtract(Duration(hours: 2)),
    updatedAt: DateTime.now().subtract(Duration(hours: 1)),
  ),
   Post(
    id: 'p4',
    title: '在京都街头拍下一缕傍晚光影',
    author: UserBaseInfo(
      id: 1,
      username: '椿小九',
      avatar: 'https://images.unsplash.com/...',
    ),
    content: '正文内容...',
    imageUrl: ['https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=900&q=80'],
    tag: '旅行日记',
    summary: '黄昏下的京都，木质町屋和灯笼的味道。',
    status: PostStatus.published,
    likes: 2480,
    viewCount: 5000,
    createdAt: DateTime.now().subtract(Duration(hours: 2)),
    updatedAt: DateTime.now().subtract(Duration(hours: 1)),
  ),
   Post(
    id: 'p5',
    title: '在京都街头拍下一缕傍晚光影',
    author: UserBaseInfo(
      id: 1,
      username: '椿小九',
      avatar: 'https://images.unsplash.com/...',
    ),
    content: '正文内容...',
    imageUrl: ['https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=900&q=80'],
    tag: '旅行日记',
    summary: '黄昏下的京都，木质町屋和灯笼的味道。',
    status: PostStatus.published,
    likes: 2480,
    viewCount: 5000,
    createdAt: DateTime.now().subtract(Duration(hours: 2)),
    updatedAt: DateTime.now().subtract(Duration(hours: 1)),
  ),
  Post(
    id: 'p6',
    title: '用 Flutter 打造毛玻璃质感',
    author: UserBaseInfo(
      id: 2,
      username: '开发者 Gragon',
      avatar: 'https://images.unsplash.com/...',
    ),
    content: '正文内容...',
    imageUrl: ['https://images.unsplash.com/photo-1523475472560-d2df97ec485c?auto=format&fit=crop&w=900&q=80'],
    tag: '技术灵感',
    summary: '复刻小红书卡片的瀑布流细节。',
    status: PostStatus.published,
    likes: 1864,
    viewCount: 3200,
    createdAt: DateTime.now().subtract(Duration(hours: 5)),
        updatedAt: DateTime.now().subtract(Duration(hours: 1)),
  ),
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
    final crossAxisCount = ResponsiveHelper.valueByDevice(
      context: context,
      mobile: 2,
      desktop: 5,
    );
    final horizontalPadding = ResponsiveHelper.valueByDevice(
      context: context,
      mobile: 12.0,
      desktop: 40.0,
    );
    final spacing = ResponsiveHelper.valueByDevice(
      context: context,
      mobile: 14.0,
      desktop: 20.0,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.getMaxContentWidth(context),
          ),
          child: CustomScrollView(
            slivers: [
              // 顶部区域
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    ResponsiveHelper.valueByDevice(context: context, mobile: 25.0, desktop: 24.0),
                    horizontalPadding,
                    ResponsiveHelper.valueByDevice(context: context, mobile: 16.0, desktop: 0.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchBar(context),
                      SizedBox(height: ResponsiveHelper.valueByDevice(context: context, mobile: 14.0, desktop: 20.0)),
                      _buildTabs(context),
                      SizedBox(height: ResponsiveHelper.valueByDevice(context: context, mobile: 10.0, desktop: 24.0)),
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
                  ResponsiveHelper.valueByDevice(context: context, mobile: 20.0, desktop: 40.0),
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
                      onTap: () => Get.toNamed(
                        '/post/${post.id}',
                        arguments: post,
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

  Widget _buildSearchBar(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
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

  Widget _buildTabs(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
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

