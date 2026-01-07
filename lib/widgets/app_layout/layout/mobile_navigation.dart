import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../middlewares/auth_middleware.dart';
import '../../../pages/post/create_post_page.dart';

/// 移动端底部导航栏
class AppBottomNav extends StatelessWidget {
  final int activeIndex;

  const AppBottomNav({
    super.key,
    required this.activeIndex,
  });

  // 根据索引导航到对应路由
  void _navigateToIndex(int index) {
    switch (index) {
      case 0:
        Get.offAllNamed('/');
        break;
      case 1:
        Get.offAllNamed('/discover');
        break;
      case 2:
        Get.offAllNamed('/notifications');
        break;
      case 3:
        Get.offAllNamed('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 20,
      height: 70,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: LucideIcons.home,
            label: '首页',
            active: activeIndex == 0,
            onTap: () => _navigateToIndex(0),
          ),
          _NavItem(
            icon: LucideIcons.compass,
            label: '发现',
            active: activeIndex == 1,
            onTap: () => _navigateToIndex(1),
          ),
          const SizedBox(width: 48),
          _NavItem(
            icon: LucideIcons.messageSquare,
            label: '消息',
            active: activeIndex == 2,
            onTap: () => _navigateToIndex(2),
          ),
          _NavItem(
            icon: LucideIcons.user,
            label: '我',
            active: activeIndex == 3,
            onTap: () => _navigateToIndex(3),
          ),
        ],
      ),
    );
  }
}

/// 悬浮发布按钮
class AppFab extends StatelessWidget {
  const AppFab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
        ),
      ),
      child: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.transparent,
        onPressed: () {
          // 检查登录状态
          if (AuthGuard.check(message: '发布内容需要先登录')) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreatePostPage()),
            );
          }
        },
        child: const Icon(LucideIcons.plus, color: Colors.white, size: 30),
      ),
    );
  }
}

// ==================== 内部组件 ====================

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
          Icon(
            icon,
            size: 22,
            color: active ? Colors.redAccent : Colors.black45,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: active ? Colors.redAccent : Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}
