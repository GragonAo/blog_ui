import 'package:flutter/material.dart';

/// 登录页底部其他登录方式组件
class LoginBottomSection extends StatelessWidget {
  final VoidCallback onWechatTap;
  final VoidCallback onWeb3Tap;

  const LoginBottomSection({
    super.key,
    required this.onWechatTap,
    required this.onWeb3Tap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "其他方式登录",
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialLoginButton(
              icon: Icons.wechat,
              color: Colors.green,
              label: "微信",
              onTap: onWechatTap,
            ),
            const SizedBox(width: 50),
            _SocialLoginButton(
              icon: Icons.account_balance_wallet,
              color: Colors.blue,
              label: "Web3",
              onTap: onWeb3Tap,
            ),
          ],
        ),
      ],
    );
  }
}

/// 社交登录按钮
class _SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _SocialLoginButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
