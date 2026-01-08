import 'package:blog_ui/config/web3_config.dart';
import 'package:blog_ui/utils/web3_js_interop.dart';
import 'package:blog_ui/services/loggeer.dart';
import 'package:flutter/foundation.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

/// 专门负责与钱包（浏览器插件或 WalletConnect）进行原始交互
class Web3Manager {
  Web3App? _wcClient;
  SessionData? _sessionData;

  /// 初始化环境
  Future<void> init() async {
    if (kIsWeb) return; // Web 端使用浏览器插件，无需初始化 WC
    try {
      _wcClient = await Web3App.createInstance(
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
      getLogger().e('Web3Manager Init Error', error: e);
    }
  }

  /// 获取钱包地址 (统一入口)
  Future<String?> connect({Function(String uri)? onDisplayUri}) async {
    if (kIsWeb) {
      return await Web3JsInterop.requestAccounts();
    } else {
      return await _connectMobile(onDisplayUri);
    }
  }

  /// 移动端 WalletConnect 连接逻辑
  Future<String?> _connectMobile(Function(String uri)? onDisplayUri) async {
    if (_wcClient == null) await init();

    // 清理旧会话
    for (var s in _wcClient!.sessions.getAll()) {
      await _wcClient!.disconnectSession(
        topic: s.topic,
        reason: Errors.getSdkError(Errors.USER_DISCONNECTED),
      );
    }

    final connectResponse = await _wcClient!.connect(
      requiredNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:1'],
          methods: ['personal_sign', 'eth_sendTransaction'],
          events: ['chainChanged', 'accountsChanged'],
        ),
      },
    );

    if (connectResponse.uri != null) {
      onDisplayUri?.call(connectResponse.uri.toString());
    }

    _sessionData = await connectResponse.session.future;
    return NamespaceUtils.getAccount(_sessionData!.namespaces.values.first.accounts.first);
  }

  /// 统一签名方法
  Future<String?> signMessage(String message, String address) async {
    try {
      if (kIsWeb) {
        return await Web3JsInterop.personalSign(message, address);
      } else {
        final result = await _wcClient!.request(
          topic: _sessionData!.topic,
          chainId: 'eip155:1',
          request: SessionRequestParams(
            method: 'personal_sign',
            params: [message, address],
          ),
        );
        return result.toString();
      }
    } catch (e) {
      getLogger().e('Signature Error', error: e);
      return null;
    }
  }

  /// 获取当前 ChainId
  Future<String> getChainId() async {
    if (kIsWeb) {
      final id = await Web3JsInterop.getChainId();
      if (id != null && id.startsWith('0x')) {
        return int.parse(id.substring(2), radix: 16).toString();
      }
      return id ?? '1';
    }
    return '1';
  }

  /// 登出时清理
  Future<void> clearSession() async {
    if (!kIsWeb && _wcClient != null && _sessionData != null) {
      try {
        await _wcClient!.disconnectSession(
          topic: _sessionData!.topic,
          reason: Errors.getSdkError(Errors.USER_DISCONNECTED),
        );
      } catch (_) {}
    }
    _sessionData = null;
  }
}