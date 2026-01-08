import 'package:flutter/material.dart';

class Web2LoginPage extends StatelessWidget {
  final bool isAgreed;
  const Web2LoginPage({super.key, required this.isAgreed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('登录', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: '手机号',
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: '验证码',
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              suffixIcon: TextButton(onPressed: () {}, child: const Text('获取')),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isAgreed ? () {} : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF2442),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
            child: const Text('立即登录', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}