import 'package:blog_ui/http/api.dart';
import 'package:blog_ui/http/init.dart';
import 'package:blog_ui/models/user/info.dart';
import 'package:blog_ui/pages/login/components/login_dialog.dart';
import 'package:blog_ui/utils/storage.dart';
import 'package:blog_ui/services/loggeer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'web3_manager.dart';

class AuthService extends GetxController {
  static AuthService get to => Get.find();

  // --- 依赖注入 ---
  final Web3Manager _web3 = Web3Manager();

  // --- 响应式状态 ---
  final RxBool isLoggedIn = false.obs;
  final RxBool isConnecting = false.obs;
  final Rx<UserInfoData?> userInfo = Rx<UserInfoData?>(null);
  final RxString walletAddress = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _web3.init();
    _loadAuthState();
  }

  // ================= 核心业务：Web3 登录 =================

  Future<void> loginWithWeb3() async {
    if (isConnecting.value) return;
    
    try {
      isConnecting.value = true;
      
      // 1. 连接钱包获取地址
      final address = await _web3.connect(onDisplayUri: (uri) => _showQRCodeDialog(uri));
      if (address == null || address.isEmpty) {
        SmartDialog.showToast('连接已取消');
        return;
      }
      walletAddress.value = address;

      // 2. 从后端获取 Nonce
      final chainId = await _web3.getChainId();
      final nonce = await _fetchNonce(address, chainId);
      if (nonce == null) return;

      // 3. 请求签名
      SmartDialog.showToast('请在钱包中确认签名');
      final message = 'Sign this message to authenticate with Blog UI\nNonce: $nonce';
      final signature = await _web3.signMessage(message, address);
      if (signature == null) return;

      // 4. 提交后端验证登录
      await _submitLogin(message, signature);

    } catch (e) {
      getLogger().e('Web3 Login Flow Error', error: e);
      SmartDialog.showToast('登录失败: $e');
    } finally {
      isConnecting.value = false;
    }
  }

  // ================= 辅助业务方法 =================

  Future<String?> _fetchNonce(String address, String chainId) async {
    final res = await Request().get(Api.blogLoginWeb3Nonce, data: {
      'chain_id': chainId,
      'address': address,
    });
    if (res.data['code'] == 0) {
      return res.data['data'].toString();
    }
    SmartDialog.showToast(res.data['message'] ?? '获取Nonce失败');
    return null;
  }

  Future<void> _submitLogin(String message, String signature) async {
    final res = await Request().post(Api.blogLoginWeb3, data: {
      'message': message,
      'signature': signature,
    });

    if (res.data['code'] == 0) {
      final token = res.data['data']['access_token'].toString();
      await GStrorage.localCache.put(LocalCacheKey.accessToken, token);
      isLoggedIn.value = true;
      userInfo.value = await Request().get(Api.blogUserInfo).then((response) {
        if (response.data['code'] == 0) {
          return UserInfoData.fromJson(Map<String, dynamic>.from(response.data['data']));
        }
        return null;
      });
      await GStrorage.setting.put('user_info', userInfo.value!);
      _handleLoginSuccess();
    } else {
      SmartDialog.showToast(res.data['message'] ?? '认证验证失败');
    }
  }

  void _handleLoginSuccess() {
    SmartDialog.showToast('登录成功');
    // 如果是弹窗，关闭弹窗
    if (Get.isDialogOpen ?? false) {
      Get.back();
      return;
    }
    
    // 检查是否有重定向参数（来自中间件）
    final redirect = Get.parameters['redirect'];
    if (redirect != null && redirect.isNotEmpty) {
      Get.offNamed(redirect);
      return;
    }
    
    // 检查当前路由，如果在登录页则返回主页
    if (Get.currentRoute == '/login') {
      Get.offAllNamed('/');
    }
  }

  // ================= 状态管理 =================

  void _loadAuthState() {
    final token = GStrorage.localCache.get(LocalCacheKey.accessToken);
    final savedUserJson = GStrorage.setting.get('user_info');

    if (token != null && token.isNotEmpty) {
      isLoggedIn.value = true;
      if (savedUserJson != null) {
        userInfo.value = UserInfoData.fromJson(Map<String, dynamic>.from(savedUserJson));
      }
    }
  }

  Future<void> _saveAuthState(String token) async {

  }

  Future<void> logout() async {
    await _web3.clearSession();
    await GStrorage.localCache.delete(LocalCacheKey.accessToken);
    await GStrorage.setting.delete('user_info');

    isLoggedIn.value = false;
    userInfo.value = null;
    walletAddress.value = '';
    
    SmartDialog.showToast('已安全退出');
  }

  bool requireAuth({String? message}) {
    if (!isLoggedIn.value) {
      SmartDialog.showToast(message ?? '请先登录');
      Get.width > 768 ? Get.dialog(const LoginDialog()) : Get.toNamed('/login');
      return false;
    }
    return true;
  }

  void _showQRCodeDialog(String uri) {
    Get.dialog(
      AlertDialog(
        title: const Text('连接钱包'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.qr_code_2, size: 150),
            const SizedBox(height: 10),
            const Text('请使用手机钱包扫码连接', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 10),
            SelectableText(uri, style: const TextStyle(fontSize: 8, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}