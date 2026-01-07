import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import '../../../services/auth_service.dart';
import '../../../utils/web3_js_interop.dart';

/// 简化登录对话框
/// 
/// 职责：
/// - 提供快捷登录入口
/// - 内置手机号和 Web3 登录
/// - 独立的 UI 实现，不依赖登录控制器
/// 
/// 使用场景：
/// - 导航栏登录按钮
/// - 需要快速登录的场景
/// - 不需要完整登录页面功能的场景
/// 
/// 与 DesktopLogin 的区别：
/// - LoginDialog：简化版，内置表单，直接调用 AuthService
/// - DesktopLogin：完整版，使用 LoginPageController，支持更多功能
class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  bool _agreeProtocol = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 500,
          maxHeight: 700,
        ),
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
            // 登录内容
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Column(
                children: [
                  Expanded(
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

                          // 手机号输入
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: '输入手机号',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.only(left: 16, right: 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '+86',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      SizedBox(
                                        height: 20,
                                        child: VerticalDivider(thickness: 1),
                                      ),
                                    ],
                                  ),
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // 验证码输入
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: _codeController,
                              decoration: InputDecoration(
                                hintText: '输入验证码',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                suffixIcon: TextButton(
                                  onPressed: () {
                                    Get.snackbar('验证码', '验证码已发送');
                                  },
                                  child: const Text('获取验证码'),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // 登录按钮
                          ElevatedButton(
                            onPressed: _agreeProtocol
                                ? () {
                                    Get.snackbar('提示', '登录功能开发中');
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF2442),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey[300],
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              '登录',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // 协议勾选
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  value: _agreeProtocol,
                                  onChanged: (value) {
                                    setState(() {
                                      _agreeProtocol = value ?? false;
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  activeColor: const Color(0xFFFF2442),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Wrap(
                                  children: [
                                    Text(
                                      '我已阅读并同意',
                                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: const Text(
                                        '《用户协议》',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFFFF2442),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '和',
                                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: const Text(
                                        '《隐私政策》',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFFFF2442),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Web3 登录分割线
                          Row(
                            children: [
                              Expanded(child: Divider(color: Colors.grey[300])),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Web3 登录',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              Expanded(child: Divider(color: Colors.grey[300])),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Web3 钱包按钮
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildWeb3Icon(
                                emoji: '🦊',
                                label: 'MetaMask',
                                onTap: _connectMetaMask,
                              ),
                              const SizedBox(width: 40),
                              _buildWeb3Icon(
                                emoji: '🔗',
                                label: 'WalletConnect',
                                onTap: () {
                                  SmartDialog.showToast('WalletConnect 仅在移动端可用');
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
    );
  }

  // 连接 MetaMask
  Future<void> _connectMetaMask() async {
    if (!kIsWeb) {
      SmartDialog.showToast('MetaMask 仅在 Web 平台可用');
      return;
    }

    if (!Web3JsInterop.isMetaMaskAvailable) {
      SmartDialog.showToast('请先安装 MetaMask 浏览器扩展');
      return;
    }

    try {
      SmartDialog.showToast('请在 MetaMask 中确认连接');
      
      final address = await Web3JsInterop.requestAccounts();
      
      if (address != null && address.isNotEmpty) {
        // 调用认证服务登录
        final authService = AuthService.to;
        final success = await authService.loginWithWeb3(address);
        
        if (success) {
          SmartDialog.showToast('MetaMask 连接成功');
          Get.back(); // 关闭对话框
        }
      } else {
        SmartDialog.showToast('连接被拒绝');
      }
    } catch (e) {
      SmartDialog.showToast('连接失败: $e');
    }
  }

  Widget _buildWeb3Icon({
    required String emoji,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
