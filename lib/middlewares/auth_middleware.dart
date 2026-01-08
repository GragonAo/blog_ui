import 'package:blog_ui/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 路由认证中间件 - 保护需要登录的路由
class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // 检查用户是否已登录
    final authService = Get.find<AuthService>();
    
    if (!authService.isLoggedIn.value) {
      // 未登录，保存原始路由并重定向到登录页
      Get.snackbar(
        '需要登录',
        '请先登录后再访问此页面',
        duration: const Duration(seconds: 2),
      );
      
      // 保存原始路由，登录成功后可以返回
      if (route != null && route != '/login') {
        Get.parameters['redirect'] = route;
      }
      
      return const RouteSettings(name: '/login');
    }
    
    return null; // 已登录，允许访问
  }
}

/// 路由权限装饰器 - 用于包装需要权限的操作
class AuthGuard {
  /// 执行需要登录的操作
  static Future<T?> execute<T>({
    required Future<T> Function() action,
    String? message,
  }) async {
    final authService = AuthService.to;
    
    if (authService.requireAuth(message: message)) {
      return await action();
    }
    
    return null;
  }

  /// 检查是否已登录（同步方法）
  static bool check({String? message}) {
    return AuthService.to.requireAuth(message: message);
  }

  /// 执行需要登录的同步操作
  static T? executeSync<T>({
    required T Function() action,
    String? message,
  }) {
    if (AuthService.to.requireAuth(message: message)) {
      return action();
    }
    return null;
  }
}
