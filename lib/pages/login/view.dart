import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';
import 'components/connected_view.dart';
import 'layouts/mobile_login.dart';
import 'layouts/desktop_login.dart';

/// 登录页面 - 响应式入口
/// 
/// 职责：
/// - 根据屏幕宽度选择对应的布局实现
/// - 管理登录控制器生命周期
/// - 统一处理连接状态的视图切换
/// 
/// 布局选择：
/// - 桌面端（>768px）：[DesktopLogin] - 弹窗样式
/// - 移动端（≤768px）：[MobileLogin] - 全屏样式
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final LoginPageController _loginPageCtr = Get.put(LoginPageController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 768;

    return Obx(() {
      // 如果已连接，显示连接后的视图
      if (_loginPageCtr.isConnected.value) {
        return Scaffold(
          body: ConnectedView(controller: _loginPageCtr),
        );
      }

      // 根据屏幕大小选择登录界面
      if (isLargeScreen) {
        return DesktopLogin(controller: _loginPageCtr);
      } else {
        return MobileLogin(controller: _loginPageCtr);
      }
    });
  }
}
