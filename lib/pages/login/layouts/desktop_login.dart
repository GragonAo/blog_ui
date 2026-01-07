import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller.dart';
import '../components/phone_login_form.dart';
import '../components/web3_login_section.dart';

/// 桌面端登录界面
/// 
/// 样式特点：
/// - 弹窗样式，居中显示
/// - 半透明黑色背景蒙层
/// - 圆角卡片容器
/// - 右上角关闭按钮
/// - 紧凑的间距设计
/// 
/// 使用场景：
/// - 大屏设备（宽度 > 768px）
/// - 作为 modal 弹窗使用
class DesktopLogin extends StatelessWidget {
  final LoginPageController controller;

  const DesktopLogin({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.2),
      body: GestureDetector(
        onTap: () => Get.back(),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // 阻止点击事件穿透
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 500,
                maxHeight: 700,
              ),
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  _buildContent(),
                  // 关闭按钮
                  Positioned(
                    top: 16,
                    right: 16,
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(32, 60, 32, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  const Text(
                    '登录',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '未注册的手机号登录后将自动创建账号',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 手机号登录表单
                  const PhoneLoginForm(),
                  const SizedBox(height: 24),

                  // Web3 登录区域
                  Web3LoginSection(controller: controller),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
