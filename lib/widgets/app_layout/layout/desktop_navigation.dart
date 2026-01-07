import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../middlewares/auth_middleware.dart';
import '../../../pages/post/create_post_page.dart';
import '../../../pages/login/components/login_dialog.dart';

/// 桌面端侧边导航栏
class DesktopSideNav extends StatelessWidget {
  final int activeIndex;

  const DesktopSideNav({
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
    const navItems = [
      _NavItemData(LucideIcons.home, '首页'),
      _NavItemData(LucideIcons.compass, '发现'),
      _NavItemData(LucideIcons.messageSquare, '消息'),
      _NavItemData(LucideIcons.user, '我'),
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
          // Logo 和登录按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SulSul博客',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
             ],
          ),
          const SizedBox(height: 24),

          // 导航项
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
                onTap: () => _navigateToIndex(index),
              ),
            );
          }),
          const Spacer(),

          // 发布按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // 检查登录状态
                if (AuthGuard.check(message: '发布内容需要先登录')) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CreatePostPage()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(LucideIcons.plus, size: 18),
              label: const Text(
                '发布',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== 内部组件 ====================

class _NavItemData {
  final IconData icon;
  final String label;
  const _NavItemData(this.icon, this.label);
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: active ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: active ? Colors.white : Colors.black54,
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: active ? Colors.white : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
