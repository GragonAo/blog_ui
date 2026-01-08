import 'package:flutter/material.dart';

/// 移动端 Web3 钱包登录组件
class Web3LoginMobile extends StatelessWidget {
  final bool isAgreed;
  final VoidCallback onBack;
  final Function(String walletName) onWalletTap;

  const Web3LoginMobile({
    super.key,
    required this.isAgreed,
    required this.onBack,
    required this.onWalletTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.account_balance_wallet,
            size: 60,
            color: Color(0xFFFF2442),
          ),
          const SizedBox(height: 16),
          const Text(
            'Web3 钱包登录',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '使用您的加密钱包安全登录',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          _WalletOption(
            name: 'MetaMask',
            iconUrl: 'https://i.postimg.cc/85z9p8vX/metamask.png',
            label: 'Popular',
            isAgreed: isAgreed,
            onTap: () => onWalletTap('MetaMask'),
          ),
          const SizedBox(height: 12),
          _WalletOption(
            name: 'Phantom',
            iconUrl: 'https://i.postimg.cc/85z9p8vX/phantom.png',
            label: 'Solana',
            isAgreed: isAgreed,
            onTap: () => onWalletTap('Phantom'),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: onBack,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey[300]!),
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('返回', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

/// 钱包选项卡片
class _WalletOption extends StatelessWidget {
  final String name;
  final String iconUrl;
  final String label;
  final bool isAgreed;
  final VoidCallback onTap;

  const _WalletOption({
    required this.name,
    required this.iconUrl,
    required this.label,
    required this.isAgreed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isAgreed
          ? onTap
          : () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('请先同意用户协议')),
              );
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Image.network(
              iconUrl,
              width: 32,
              height: 32,
              errorBuilder: (c, e, s) => const Icon(Icons.wallet, size: 32),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
