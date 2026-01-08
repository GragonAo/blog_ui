import 'package:blog_ui/pages/login/components/web2_login.dart';
import 'package:blog_ui/pages/login/components/web3_login_mobile.dart';
import 'package:blog_ui/pages/login/components/login_header.dart';
import 'package:blog_ui/pages/login/components/login_protocol_row.dart';
import 'package:blog_ui/pages/login/components/login_bottom_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum LoginMode { web2, web3 }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _agreeProtocol = false;
  LoginMode _currentMode = LoginMode.web2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            // 如果能返回就返回，否则跳转到主页
            if (Navigator.canPop(context)) {
              Get.back();
            } else {
              Get.offAllNamed('/');
            }
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo 或标题区域
              const SizedBox(height: 20),
              const Center(child: LoginHeader()),
              const SizedBox(height: 40),

              // 登录方式内容
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _currentMode == LoginMode.web2
                    ? _buildWeb2Content()
                    : _buildWeb3Content(),
              ),

              const SizedBox(height: 24),

              // 协议勾选
              LoginProtocolRow(
                agreeProtocol: _agreeProtocol,
                onChanged: (val) => setState(() => _agreeProtocol = val),
              ),

              const SizedBox(height: 10),

              // 底部切换方式（仅在 Web2 模式显示）
              if (_currentMode == LoginMode.web2)
                LoginBottomSection(
                  onWechatTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('微信登录功能开发中')),
                    );
                  },
                  onWeb3Tap: () => setState(() => _currentMode = LoginMode.web3),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeb2Content() {
    return Column(
      key: const ValueKey('web2'),
      children: [
        Web2LoginPage(isAgreed: _agreeProtocol),
      ],
    );
  }

  Widget _buildWeb3Content() {
    return Column(
      key: const ValueKey('web3'),
      children: [
        Web3LoginMobile(
          isAgreed: _agreeProtocol,
          onBack: () => setState(() => _currentMode = LoginMode.web2),
          onWalletTap: (walletName) {
            // 调用 Web3 登录
            debugPrint('连接 $walletName 钱包');
          },
        ),
      ],
    );
  }
}
