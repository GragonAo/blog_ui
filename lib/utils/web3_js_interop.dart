// Web3 JavaScript Interop
// 用于在 Web 平台与 MetaMask 等钱包交互

import 'dart:async';
import 'dart:js_interop';
import 'package:flutter/foundation.dart';

// 定义 Ethereum 对象接口
@JS()
@staticInterop
class Ethereum {}

extension EthereumExtension on Ethereum {
  external JSPromise request(JSObject params);
  external void on(JSString event, JSFunction callback);
}

// 获取 window.ethereum
@JS('window.ethereum')
external Ethereum? get ethereum;

class Web3JsInterop {
  static bool get isMetaMaskAvailable {
    if (!kIsWeb) return false;
    try {
      return ethereum != null;
    } catch (e) {
      return false;
    }
  }

  // 请求连接账户
  static Future<String?> requestAccounts() async {
    if (!kIsWeb || !isMetaMaskAvailable) return null;

    try {
      final eth = ethereum;
      if (eth == null) return null;

      final params = {'method': 'eth_requestAccounts'.toJS}.jsify() as JSObject;
      final promise = eth.request(params);

      final result = await promise.toDart;
      final accounts = result as JSArray;
      
      if (accounts.length > 0) {
        return (accounts[0] as JSString).toDart;
      }
      return null;
    } catch (e) {
      print('Request accounts error: $e');
      return null;
    }
  }

  // 获取当前账户
  static Future<String?> getCurrentAccount() async {
    if (!kIsWeb || !isMetaMaskAvailable) return null;

    try {
      final eth = ethereum;
      if (eth == null) return null;

      final params = {'method': 'eth_accounts'.toJS}.jsify() as JSObject;
      final promise = eth.request(params);

      final result = await promise.toDart;
      final accounts = result as JSArray;
      
      if (accounts.length > 0) {
        return (accounts[0] as JSString).toDart;
      }
      return null;
    } catch (e) {
      print('Get current account error: $e');
      return null;
    }
  }

  // 请求签名
  static Future<String?> personalSign(String message, String account) async {
    if (!kIsWeb || !isMetaMaskAvailable) return null;

    try {
      final eth = ethereum;
      if (eth == null) return null;

      final params = {
        'method': 'personal_sign'.toJS,
        'params': [message.toJS, account.toJS].toJS
      }.jsify() as JSObject;

      final promise = eth.request(params);
      final result = await promise.toDart;
      
      return (result as JSString).toDart;
    } catch (e) {
      print('Personal sign error: $e');
      return null;
    }
  }

  // 监听账户变化
  static void onAccountsChanged(Function(List<String>) callback) {
    if (!kIsWeb || !isMetaMaskAvailable) return;

    try {
      final eth = ethereum;
      if (eth == null) return;

      final jsCallback = ((JSArray accounts) {
        final dartAccounts = <String>[];
        for (var i = 0; i < accounts.length; i++) {
          dartAccounts.add((accounts[i] as JSString).toDart);
        }
        callback(dartAccounts);
      }).toJS;

      eth.on('accountsChanged'.toJS, jsCallback);
    } catch (e) {
      print('Listen accounts changed error: $e');
    }
  }

  // 监听链变化
  static void onChainChanged(Function(String) callback) {
    if (!kIsWeb || !isMetaMaskAvailable) return;

    try {
      final eth = ethereum;
      if (eth == null) return;

      final jsCallback = ((JSString chainId) {
        callback(chainId.toDart);
      }).toJS;

      eth.on('chainChanged'.toJS, jsCallback);
    } catch (e) {
      print('Listen chain changed error: $e');
    }
  }

  // 获取当前链ID
  static Future<String?> getChainId() async {
    if (!kIsWeb || !isMetaMaskAvailable) return null;

    try {
      final eth = ethereum;
      if (eth == null) return null;

      final params = {'method': 'eth_chainId'.toJS}.jsify() as JSObject;
      final promise = eth.request(params);

      final result = await promise.toDart;
      return (result as JSString).toDart;
    } catch (e) {
      print('Get chain ID error: $e');
      return null;
    }
  }

  // 切换网络
  static Future<bool> switchChain(String chainId) async {
    if (!kIsWeb || !isMetaMaskAvailable) return false;

    try {
      final eth = ethereum;
      if (eth == null) return false;

      final params = {
        'method': 'wallet_switchEthereumChain'.toJS,
        'params': [
          {'chainId': chainId.toJS}.jsify() as JSObject
        ].toJS
      }.jsify() as JSObject;

      final promise = eth.request(params);
      await promise.toDart;
      
      return true;
    } catch (e) {
      print('Switch chain error: $e');
      return false;
    }
  }
}
