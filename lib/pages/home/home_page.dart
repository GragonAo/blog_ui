import 'package:blog_ui/models/articles/article_model.dart';
import 'package:blog_ui/http/index.dart'; // Import ArticleHttp
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
  List<Article> _articles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    try {
      final result = await ArticleHttp.getArticleList(
        page: 1, 
        pageSize: 20
      );
      if (mounted) {
        setState(() {
          _articles = result.list;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load articles: $e')),
        );
      }
    }
  }

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
              if (_isLoading)
                const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              else if (_articles.isEmpty)
                const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Text('暂无文章', style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                )
              else
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
                  childCount: _articles.length,
                  itemBuilder: (context, index) {
                    final article = _articles[index];
                    return BlogCard(
                      article: article,
                      index: index,
                      onTap: () => Get.toNamed(
                        '/post/${article.id}'
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

