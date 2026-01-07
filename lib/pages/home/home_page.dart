import 'package:flutter/material.dart';
import 'package:blog_ui/models/post_model.dart';
import 'layout/mobile_home.dart';
import 'layout/desktop_home.dart';

/// 首页 - 响应式容器
/// 
/// 根据屏幕宽度自动选择桌面或移动端实现：
/// - 桌面端（>900px）：DesktopHome
/// - 移动端（≤900px）：MobileHome
class HomePage extends StatelessWidget {
  const HomePage({super.key});

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

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    if (isDesktop) {
      return DesktopHome(posts: _posts);
    }

    return MobileHome(posts: _posts);
  }
}

