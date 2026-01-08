import 'package:blog_ui/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Web3ModalPage extends StatefulWidget {
  final bool isAgreed;
  final VoidCallback onBack;
  const Web3ModalPage({
    super.key,
    required this.isAgreed,
    required this.onBack,
  });

  @override
  State<Web3ModalPage> createState() => _Web3ModalPageState();
}

class _Web3ModalPageState extends State<Web3ModalPage> {
  final List<Wallet> walletList = [
    Wallet(
      name: 'MetaMask',
      icon: 'https://i.postimg.cc/85z9p8vX/metamask.png',
      remark: 'Popular',
    ),
    Wallet(
      name: 'Phantom',
      icon: 'https://i.postimg.cc/85z9p8vX/phantom.png',
      remark: 'Solana',
    ),
  ];
  int selectedIndex = 0;

  void _connectInjectedWallet() async {
    debugPrint("正在尝试唤起 ${walletList[selectedIndex].name} 浏览器插件...");
    // 弹个反馈
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("正在唤起 ${walletList[selectedIndex].name} 插件...")),
    );
    await AuthService.to.loginWithWeb3();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 如果宽度还没撑开（比如小于 500），只返回一个空容器或 Loading
        if (constraints.maxWidth < 500) return const SizedBox(height: 380);
        return Container(
          height: 400,
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  // --- 左侧钱包列表 ---
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        border: Border(
                          right: BorderSide(color: Colors.grey[200]!),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 45),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              "选择钱包",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: walletList.length,
                              itemBuilder: (context, index) {
                                bool isSelected = selectedIndex == index;
                                return ListTile(
                                  selected: isSelected,
                                  selectedTileColor: Colors.white,
                                  leading: Image.network(
                                    walletList[index].icon,
                                    width: 24,
                                    errorBuilder: (c, e, s) =>
                                        const Icon(Icons.wallet),
                                  ),
                                  title: Text(
                                    walletList[index].name,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  onTap: () =>
                                      setState(() => selectedIndex = index),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- 右侧详情区 ---
                  Expanded(
                    flex: 6,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: widget.isAgreed ? 1.0 : 0.4,
                      child: IgnorePointer(
                        ignoring: !widget.isAgreed,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "连接 ${walletList[selectedIndex].name}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (kIsWeb) ...[
                                OutlinedButton.icon(
                                  onPressed: widget.isAgreed
                                      ? _connectInjectedWallet
                                      : null,
                                  icon: const Icon(Icons.extension, size: 18),
                                  label: const Text("打开浏览器插件"),
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(
                                      double.infinity,
                                      45,
                                    ),
                                    side: BorderSide(
                                      color: widget.isAgreed
                                          ? Colors.blue
                                          : Colors.grey,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const Expanded(child: Divider()),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Text(
                                        "或使用扫码",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                    const Expanded(child: Divider()),
                                  ],
                                ),
                                const SizedBox(height: 16),
                              ],

                              // 二维码区域
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[100]!),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey[50],
                                ),
                                child: const Icon(Icons.qr_code_2, size: 180),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "还没有钱包？点击了解更多",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // 左上角返回
              Positioned(
                top: 8,
                left: 8,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: Colors.grey,
                  ),
                  onPressed: widget.onBack,
                  tooltip: '返回登录',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Wallet {
  final String name;
  final String icon;
  final String? remark;
  Wallet({required this.name, required this.icon, this.remark});
}
