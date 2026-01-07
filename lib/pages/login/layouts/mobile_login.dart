import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller.dart';
import '../components/phone_login_form.dart';
import '../components/web3_login_section.dart';

/// 移动端登录界面
/// 
/// 样式特点：
/// - 全屏界面
/// - 顶部工具栏（其他方式、关闭按钮）
/// - 大字号标题（32px）
/// - 宽松的间距设计
/// - SafeArea 保护
/// 
/// 使用场景：
/// - 小屏设备（宽度 ≤ 768px）
/// - 移动端原生体验
class MobileLogin extends StatelessWidget {
  final LoginPageController controller;

  const MobileLogin({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // 顶部工具栏
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // 显示更多登录方式
                    },
                    icon: const Icon(Icons.more_horiz, size: 20),
                    label: const Text('其他方式'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black87,
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            // 可滚动内容
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // 标题
                    const Text(
                      '登录',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '未注册的手机号登录后将自动创建账号',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // 手机号登录表单
                    const PhoneLoginForm(),
                    const SizedBox(height: 32),

                    // Web3 登录区域
                    Web3LoginSection(controller: controller),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
