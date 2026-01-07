import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';

/// 手机号登录表单组件
/// 
/// 功能：
/// - 手机号输入（+86 国际区号）
/// - 验证码/密码切换
/// - 获取验证码按钮
/// - 协议勾选
/// - 登录逻辑调用

class PhoneLoginForm extends StatefulWidget {
  const PhoneLoginForm({super.key});

  @override
  State<PhoneLoginForm> createState() => _PhoneLoginFormState();
}

class _PhoneLoginFormState extends State<PhoneLoginForm> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  bool _usePassword = false;
  bool _agreeProtocol = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final phone = _phoneController.text.trim();
    final code = _codeController.text.trim();

    if (phone.isEmpty) {
      Get.snackbar('提示', '请输入手机号');
      return;
    }

    if (code.isEmpty) {
      Get.snackbar('提示', _usePassword ? '请输入密码' : '请输入验证码');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = AuthService.to;
      final success = await authService.login(
        phone: phone,
        code: code,
      );

      if (success) {
        Get.back(); // 关闭登录页面
        Get.snackbar(
          '登录成功',
          '欢迎回来！',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green[400],
          colorText: Colors.white,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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

        // 验证码/密码输入
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _codeController,
            obscureText: _usePassword,
            decoration: InputDecoration(
              hintText: _usePassword ? '输入密码' : '输入验证码',
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              suffixIcon: _usePassword
                  ? null
                  : TextButton(
                      onPressed: () {
                        Get.snackbar('验证码', '验证码已发送');
                      },
                      child: const Text('获取验证码'),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // 切换登录方式
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              setState(() {
                _usePassword = !_usePassword;
                _codeController.clear();
              });
            },
            child: Text(
              _usePassword ? '验证码登录' : '密码登录',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // 登录按钮
        ElevatedButton(
          onPressed: (_agreeProtocol && !_isLoading) ? _handleLogin : null,
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
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
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
      ],
    );
  }
}
