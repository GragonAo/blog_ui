import 'package:blog_ui/common/skeleton/skeleton.dart';
import 'package:blog_ui/utils/platform/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// 文章详情页骨架屏
class PostDetailSkeleton extends StatelessWidget {
  const PostDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      return _DesktopSkeleton();
    } else {
      return _MobileSkeleton();
    }
  }
}

/// 桌面端骨架屏
class _DesktopSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          '文章详情',
          style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 左侧主内容区
              Expanded(
                flex: 7,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 头图骨架
                        Skeleton(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Container(color: Colors.grey.shade300),
                            ),
                          ),
                        ),
                        // 内容骨架
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 标签
                              Skeleton(
                                child: Container(
                                  width: 80,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // 标题
                              Skeleton(
                                child: Container(
                                  width: double.infinity,
                                  height: 36,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Skeleton(
                                child: Container(
                                  width: 300,
                                  height: 36,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              const SizedBox(height: 12),
                              // 时间
                              Skeleton(
                                child: Container(
                                  width: 120,
                                  height: 16,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              const Divider(height: 32),
                              // 描述
                              ...List.generate(
                                3,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Skeleton(
                                    child: Container(
                                      width: index == 2 ? 200 : double.infinity,
                                      height: 20,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              // 内容行
                              ...List.generate(
                                8,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Skeleton(
                                    child: Container(
                                      width: index % 3 == 0 ? 250 : double.infinity,
                                      height: 18,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // 右侧边栏
              Container(
                width: 320,
                margin: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                child: Column(
                  children: [
                    // 作者卡片骨架
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Skeleton(
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey.shade300,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Skeleton(
                            child: Container(
                              width: 120,
                              height: 20,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Skeleton(
                            child: Container(
                              width: 100,
                              height: 14,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Skeleton(
                            child: Container(
                              width: double.infinity,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 移动端骨架屏
class _MobileSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 360,
            pinned: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(LucideIcons.arrowLeft, color: Colors.black87),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Skeleton(
                child: Container(color: Colors.grey.shade300),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标签
                  Skeleton(
                    child: Container(
                      width: 80,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 标题
                  Skeleton(
                    child: Container(
                      width: double.infinity,
                      height: 28,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Skeleton(
                    child: Container(
                      width: 200,
                      height: 28,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // 时间
                  Skeleton(
                    child: Container(
                      width: 150,
                      height: 16,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  const SizedBox(height: 18),
                  // 描述
                  ...List.generate(
                    4,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Skeleton(
                        child: Container(
                          width: index == 3 ? 150 : double.infinity,
                          height: 18,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // 内容行
                  ...List.generate(
                    10,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Skeleton(
                        child: Container(
                          width: index % 4 == 0 ? 180 : double.infinity,
                          height: 16,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  // 操作按钮
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      3,
                      (index) => Skeleton(
                        child: Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
