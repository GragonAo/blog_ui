import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(6, (i) => '你的作品获得了 ${(i + 1) * 3} 次新互动');
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('消息', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Text('互动提醒 / 系统通知 / 关注动态', style: TextStyle(color: Colors.black.withOpacity(0.6))),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 5)),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.redAccent.withOpacity(0.1),
                            child: const Icon(LucideIcons.bell, color: Colors.redAccent, size: 18),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(items[index], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          ),
                          const Icon(LucideIcons.chevronRight, size: 18, color: Colors.black38),
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
