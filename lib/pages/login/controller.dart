import 'package:blog_ui/http/api.dart';
import 'package:blog_ui/http/init.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:blog_ui/utils/storage.dart';
import 'package:blog_ui/utils/web3_js_interop.dart';
import 'package:blog_ui/config/web3_config.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:blog_ui/services/loggeer.dart';

class LoginPageController extends GetxController {
  // 钱包地址
  final walletAddress = ''.obs;
  
  // 连接状态
  final isConnecting = false.obs;
  final isConnected = false.obs;
  
  // WalletConnect
  Web3App? wcClient;
  SessionData? sessionData;

  @override
  void onInit() {
    super.onInit();
    
    if (!kIsWeb) {
      _initWalletConnect();
    }
    _checkExistingSession();
  }


  @override
  void onClose() {
    wcClient?.core.relayClient.disconnect();
    super.onClose();
  }

  // 初始化 WalletConnect
  Future<void> _initWalletConnect() async {
    try {
      wcClient = await Web3App.createInstance(
        relayUrl: 'wss://relay.walletconnect.com',
        projectId: Web3Config.walletConnectProjectId,
        metadata: PairingMetadata(
          name: Web3Config.appName,
          description: Web3Config.appDescription,
          url: Web3Config.appUrl,
          icons: Web3Config.appIcons,
        ),
      );
    } catch (e) {
      getLogger().e('WalletConnect initialization error', error: e);
    }
  }

  // 检查现有会话
  Future<void> _checkExistingSession() async {
    if (kIsWeb) {
      // Web 平台检查 MetaMask
      final address = await Web3JsInterop.getCurrentAccount();
      if (address != null && address.isNotEmpty) {
        walletAddress.value = address;
        isConnected.value = true;
      }
      return;
    }
    
    // 移动端检查 WalletConnect
    if (wcClient == null) return;
    
    final sessions = wcClient!.sessions.getAll();
    if (sessions.isNotEmpty) {
      sessionData = sessions.first;
      final address = NamespaceUtils.getAccount(
        sessionData!.namespaces.values.first.accounts.first,
      );
      walletAddress.value = address;
      isConnected.value = true;
    }
  }

  // 连接 MetaMask (Web)
  Future<void> connectMetaMask() async {
    if (!kIsWeb) {
      SmartDialog.showToast('MetaMask 仅在 Web 平台可用');
      return;
    }

    if (!Web3JsInterop.isMetaMaskAvailable) {
      SmartDialog.showToast('请先安装 MetaMask 浏览器扩展');
      return;
    }

    try {
      isConnecting.value = true;
      SmartDialog.showToast('请在 MetaMask 中确认连接');
      
      final address = await Web3JsInterop.requestAccounts();
      
      if (address != null && address.isNotEmpty) {
        walletAddress.value = address;
        isConnected.value = true;
        
        await _authenticateWithBackend();
        SmartDialog.showToast('MetaMask 连接成功');
      } else {
        SmartDialog.showToast('连接被拒绝');
      }
    } catch (e) {
      SmartDialog.showToast('连接失败: $e');
    } finally {
      isConnecting.value = false;
    }
  }

  // 连接 WalletConnect (移动端)
  Future<void> connectWalletConnect() async {
    if (kIsWeb) {
      SmartDialog.showToast('请在移动端使用 WalletConnect');
      return;
    }

    if (wcClient == null) {
      SmartDialog.showToast('WalletConnect 未初始化');
      return;
    }

    try {
      isConnecting.value = true;
      
      // 创建连接
      final ConnectResponse connectResponse = await wcClient!.connect(
        requiredNamespaces: {
          'eip155': const RequiredNamespace(
            chains: ['eip155:1'], // Ethereum Mainnet
            methods: ['eth_sendTransaction', 'personal_sign'],
            events: ['chainChanged', 'accountsChanged'],
          ),
        },
      );

      final Uri? uri = connectResponse.uri;
      if (uri != null) {
        // 显示二维码或打开钱包应用
        SmartDialog.showToast('请在钱包应用中扫描二维码');
        // 可以使用 showDialog 显示 QR 码
        _showQRCode(uri.toString());
      }

      // 等待会话批准
      final session = await connectResponse.session.future;
      sessionData = session;
      
      final address = NamespaceUtils.getAccount(
        session.namespaces.values.first.accounts.first,
      );
      
      walletAddress.value = address;
      isConnected.value = true;
      
      await _authenticateWithBackend();
      SmartDialog.showToast('钱包连接成功');
    } catch (e) {
      SmartDialog.showToast('连接失败: $e');
    } finally {
      isConnecting.value = false;
    }
  }

  // 显示 QR 码对话框
  void _showQRCode(String uri) {
    // 可以使用 SmartDialog 或 showDialog 显示二维码
    Get.dialog(
      AlertDialog(
        title: const Text('扫描二维码连接'),
        content: SizedBox(
          width: 280,
          height: 280,
          child: Center(
            child: Text('URI: $uri'), // 实际应该显示 QR 码
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  // 获取当前链 ID
  Future<String> _getCurrentChainId() async {
    try {
      if (kIsWeb) {
        // Web 平台从 MetaMask 获取
        final chainId = await Web3JsInterop.getChainId();
        if (chainId != null && chainId.isNotEmpty) {
          // 如果是十六进制格式（如 0x1），转换为十进制
          if (chainId.startsWith('0x')) {
            return int.parse(chainId.substring(2), radix: 16).toString();
          }
          return chainId;
        }
        return '1'; // 默认以太坊主网
      } else if (sessionData != null) {
        // 移动端从 WalletConnect session 获取
        final accounts = sessionData!.namespaces.values.first.accounts;
        if (accounts.isNotEmpty) {
          final chainId = accounts.first.split(':')[1];
          return chainId;
        }
      }
    } catch (e) {
      SmartDialog.showToast('获取链 ID 失败: $e');
    }
    return '1'; // 默认以太坊主网
  }

  // 请求签名
  Future<String?> requestSignature(String message) async {
    try {
      if (kIsWeb) {
        // Web 平台使用 MetaMask
        return await Web3JsInterop.personalSign(message, walletAddress.value);
      } else if (wcClient != null && sessionData != null) {
        // 移动端使用 WalletConnect
        final result = await wcClient!.request(
          topic: sessionData!.topic,
          chainId: 'eip155:1',
          request: SessionRequestParams(
            method: 'personal_sign',
            params: [message, walletAddress.value],
          ),
        );
        return result.toString();
      }
    } catch (e) {
      getLogger().e('Signature error', error: e);
      SmartDialog.showToast('签名失败: $e');
    }
    return null;
  }

  // 与后端认证
  Future<void> _authenticateWithBackend() async {
    try {
      // 1. 获取当前链 ID
      final chainId = await _getCurrentChainId();
      
      // 2. 从后端获取 nonce
      SmartDialog.showToast('正在获取认证信息...');
      final nonceResponse = await Request().get(
        Api.blogLoginWeb3Nonce,
        data: {'chain_id': chainId,'address': walletAddress.value},
      );
      
      if (nonceResponse.data['code'] != 0) {
        SmartDialog.showToast(nonceResponse.data['message'] ?? '获取 nonce 失败');
        return;
      }
      
      final nonce = nonceResponse.data['data'].toString();
      final message = 'Sign this message to authenticate with Blog UI\nNonce: $nonce';
      
      // 3. 请求签名
      SmartDialog.showToast('请在钱包中签名以完成认证');
      final signature = await requestSignature(message);
      
      if (signature == null) {
        SmartDialog.showToast('签名取消');
        return;
      }

      // 4. 发送到后端验证
      final response = await Request().post(
        Api.blogLoginWeb3,
        data: {
          'message': message,
          'signature': signature,
        },
      );

      if (response.data['code'] == 0) {
        final accessToken = response.data['data']['access_token'].toString();
        await GStrorage.localCache.put(LocalCacheKey.accessToken, accessToken);
        SmartDialog.showToast('登录成功！');
        Get.back();
      } else {
        SmartDialog.showToast(response.data['message'] ?? '登录失败');
      }
    } catch (e) {
      SmartDialog.showToast('认证失败: $e');
    }
  }

  // 断开连接
  Future<void> disconnect() async {
    try {
      if (!kIsWeb && wcClient != null && sessionData != null) {
        await wcClient!.disconnectSession(
          topic: sessionData!.topic,
          reason: Errors.getSdkError(Errors.USER_DISCONNECTED),
        );
      }
      walletAddress.value = '';
      isConnected.value = false;
      sessionData = null;
      
      SmartDialog.showToast('已断开连接');
    } catch (e) {
      SmartDialog.showToast('断开连接失败: $e');
    }
  }
}