import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../utils/storage.dart';
import '../pages/login/components/login_dialog.dart';

/// 认证服务 - 管理用户登录状态和权限
class AuthService extends GetxController {
  static AuthService get to => Get.find();

  // 用户登录状态
  final RxBool isLoggedIn = false.obs;
  
  // 用户信息
  final Rx<UserInfo?> userInfo = Rx<UserInfo?>(null);
  
  // Token
  final RxString token = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadAuthState();
  }

  /// 从本地存储加载认证状态
  void _loadAuthState() {
    final box = GStrorage.setting;
    final savedToken = box.get('auth_token', defaultValue: '');
    final savedUserJson = box.get('user_info');
    
    if (savedToken != null && savedToken.isNotEmpty) {
      token.value = savedToken;
      isLoggedIn.value = true;
      
      if (savedUserJson != null) {
        userInfo.value = UserInfo.fromJson(Map<String, dynamic>.from(savedUserJson));
      }
    }
  }

  /// 登录
  Future<bool> login({
    required String phone,
    required String code,
  }) async {
    try {
      // TODO: 调用实际的登录 API
      // final response = await ApiService.login(phone, code);
      
      // 模拟登录成功
      await Future.delayed(const Duration(seconds: 1));
      
      // 保存 token 和用户信息
      final mockToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
      final mockUser = UserInfo(
        id: '123',
        phone: phone,
        nickname: '用户${phone.substring(7)}',
        avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200',
      );
      
      await _saveAuthState(mockToken, mockUser);
      
      return true;
    } catch (e) {
      Get.snackbar(
        '登录失败',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      return false;
    }
  }

  /// Web3 登录
  Future<bool> loginWithWeb3(String walletAddress) async {
    try {
      // TODO: 调用实际的 Web3 登录 API
      await Future.delayed(const Duration(seconds: 1));
      
      final mockToken = 'web3_token_${DateTime.now().millisecondsSinceEpoch}';
      final mockUser = UserInfo(
        id: walletAddress,
        walletAddress: walletAddress,
        nickname: '${walletAddress.substring(0, 6)}...${walletAddress.substring(38)}',
        avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200',
      );
      
      await _saveAuthState(mockToken, mockUser);
      
      return true;
    } catch (e) {
      Get.snackbar(
        '登录失败',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      return false;
    }
  }

  /// 保存认证状态
  Future<void> _saveAuthState(String newToken, UserInfo user) async {
    final box = GStrorage.setting;
    
    token.value = newToken;
    userInfo.value = user;
    isLoggedIn.value = true;
    
    await box.put('auth_token', newToken);
    await box.put('user_info', user.toJson());
  }

  /// 登出
  Future<void> logout() async {
    final box = GStrorage.setting;
    
    token.value = '';
    userInfo.value = null;
    isLoggedIn.value = false;
    
    await box.delete('auth_token');
    await box.delete('user_info');
    
    Get.snackbar(
      '提示',
      '已退出登录',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  /// 检查是否需要登录，未登录则跳转登录页
  bool requireAuth({String? message}) {
    if (!isLoggedIn.value) {
      Get.snackbar(
        '需要登录',
        message ?? '请先登录后再进行操作',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        backgroundColor: const Color.fromARGB(221, 244, 243, 243),
        colorText: const Color.fromARGB(255, 73, 71, 71),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        overlayBlur: 0,
        isDismissible: true,
      );
      
      // 跳转到登录页
      final screenWidth = Get.width;
      if (screenWidth > 768) {
        // 大屏使用对话框
        _showLoginDialog();
      } else {
        // 小屏使用全屏页面
        Get.toNamed('/login');
      }
      
      return false;
    }
    return true;
  }

  /// 显示登录对话框（大屏用）
  void _showLoginDialog() {
    Get.dialog(
      const LoginDialog(),
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }

  /// 更新用户信息
  Future<void> updateUserInfo(UserInfo newUserInfo) async {
    userInfo.value = newUserInfo;
    final box = GStrorage.setting;
    await box.put('user_info', newUserInfo.toJson());
  }
}

/// 用户信息模型
class UserInfo {
  final String id;
  final String? phone;
  final String? walletAddress;
  final String nickname;
  final String avatar;
  final String? bio;

  UserInfo({
    required this.id,
    this.phone,
    this.walletAddress,
    required this.nickname,
    required this.avatar,
    this.bio,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] ?? '',
      phone: json['phone'],
      walletAddress: json['walletAddress'],
      nickname: json['nickname'] ?? '',
      avatar: json['avatar'] ?? '',
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'walletAddress': walletAddress,
      'nickname': nickname,
      'avatar': avatar,
      'bio': bio,
    };
  }
}
