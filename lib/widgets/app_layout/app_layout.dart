import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/platform/responsive_helper.dart';
import 'layout/desktop_navigation.dart';
import 'layout/mobile_navigation.dart';

/// 应用主布局 - 包含侧边栏和底部导航栏
/// 
/// 这是一个响应式布局容器，根据屏幕宽度自动选择桌面或移动端布局：
/// - 桌面端（>900px）：侧边导航栏 + 内容区域
/// - 移动端（≤900px）：底部导航栏 + 悬浮按钮
class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout({
    super.key,
    required this.child,
  });

  // 根据当前路由获取活动索引
  int _getActiveIndex(String route) {
    switch (route) {
      case '/':
        return 0;
      case '/discover':
        return 1;
      case '/notifications':
        return 2;
      case '/profile':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;
    final activeIndex = _getActiveIndex(currentRoute);

    if (ResponsiveHelper.isDesktop(context)) {
      // 桌面布局
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: Row(
          children: [
            DesktopSideNav(activeIndex: activeIndex),
            Expanded(child: child),
          ],
        ),
      );
    }

    // 移动端布局
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: child,
      floatingActionButton: activeIndex == 0 ? const AppFab() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AppBottomNav(activeIndex: activeIndex),
    );
  }
}