import 'package:blog_ui/pages/login/components/web2_login.dart';
import 'package:blog_ui/pages/login/components/web3_login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum LoginMode { web2, web3 }

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  bool _agreeProtocol = false;
  LoginMode _currentMode = LoginMode.web2;

  @override
  Widget build(BuildContext context) {
    double dialogWidth = _currentMode == LoginMode.web2 ? 400 : 750;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        width: dialogWidth,
        constraints: const BoxConstraints(maxHeight: 600, minHeight: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // 核心内容区
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(scale: animation, child: child),
                    );
                  },
                  child: _currentMode == LoginMode.web2
                      ? _buildWeb2Content()
                      : _buildWeb3Content(),
                ),
              ),

              // 关闭按钮始终在顶层
              Positioned(
                top: 14,
                right: 14,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 将 Web2 内容封装
  Widget _buildWeb2Content() {
    return Column(
      key: const ValueKey('web2'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        const Web2LoginPage(isAgreed: false), // 传入你的参数
        const SizedBox(height: 20),
        _buildProtocolRow(),
        const SizedBox(height: 20),
        _buildBottomSection(),
      ],
    );
  }

  // 将 Web3 内容封装
  Widget _buildWeb3Content() {
    return Column(
      key: const ValueKey('web3'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Web3ModalPage(
          isAgreed: _agreeProtocol,
          onBack: () => setState(() => _currentMode = LoginMode.web2),
        ),
        const SizedBox(height: 10),
        _buildProtocolRow(),
      ],
    );
  }

  /// 底部区域逻辑
  Widget _buildBottomSection() {
    if (_currentMode == LoginMode.web3) return const SizedBox.shrink();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text("其他方式登录", style: TextStyle(fontSize: 12, color: Colors.grey[400])),
              ),
              const Expanded(child: Divider()),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialBtn(Icons.wechat, Colors.green, "微信", () {}),
            const SizedBox(width: 40),
            _socialBtn(Icons.account_balance_wallet, Colors.blue, "Web3", () {
              setState(() => _currentMode = LoginMode.web3);
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildProtocolRow() {
    return Row(
      children: [
        Checkbox(
          value: _agreeProtocol,
          onChanged: (val) => setState(() => _agreeProtocol = val ?? false),
          activeColor: const Color(0xFFFF2442),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: '我已阅读并同意',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              children: [
                TextSpan(text: '《用户协议》', style: const TextStyle(color: Color(0xFFFF2442))),
                const TextSpan(text: '和'),
                TextSpan(text: '《隐私政策》', style: const TextStyle(color: Color(0xFFFF2442))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _socialBtn(IconData icon, Color color, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[50], 
            child: Icon(icon, color: color)
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}