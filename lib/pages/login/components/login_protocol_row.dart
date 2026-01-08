import 'package:flutter/material.dart';

/// 登录页协议勾选组件
class LoginProtocolRow extends StatelessWidget {
  final bool agreeProtocol;
  final ValueChanged<bool> onChanged;

  const LoginProtocolRow({
    super.key,
    required this.agreeProtocol,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: agreeProtocol,
          onChanged: (val) => onChanged(val ?? false),
          activeColor: const Color(0xFFFF2442),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: '我已阅读并同意',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              children: [
                TextSpan(
                  text: '《用户协议》',
                  style: const TextStyle(color: Color(0xFFFF2442)),
                ),
                const TextSpan(text: '和'),
                TextSpan(
                  text: '《隐私政策》',
                  style: const TextStyle(color: Color(0xFFFF2442)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
