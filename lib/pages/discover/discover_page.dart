import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('发现', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Text('精选话题 / 推荐榜单 / 热门作者', style: TextStyle(color: Colors.black.withOpacity(0.6))),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: 6,
                  itemBuilder: (_, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6)),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.redAccent.withOpacity(0.1),
                            child: Icon(LucideIcons.compass, color: Colors.redAccent.withOpacity(0.9)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('话题 #${index + 1}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                                const SizedBox(height: 6),
                                Text('发现更多灵感与创作灵感的合集，点击进入查看详情。',
                                    style: TextStyle(color: Colors.black.withOpacity(0.65), height: 1.4)),
                              ],
                            ),
                          ),
                          const Icon(LucideIcons.chevronRight, size: 18, color: Colors.black45),
                        ],
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
}
