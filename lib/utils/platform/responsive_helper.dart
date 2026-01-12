import 'package:flutter/material.dart';

/// 响应式布局工具类
/// 统一管理整个应用的响应式断点和布局判断
class ResponsiveHelper {
  /// 桌面端断点宽度
  static const double desktopBreakpoint = 900;
  
  /// 平板断点宽度
  static const double tabletBreakpoint = 600;

  /// 判断是否为桌面端布局
  /// 宽度 > 900px 视为桌面端
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > desktopBreakpoint;
  }

  /// 判断是否为平板布局
  /// 600px < 宽度 <= 900px 视为平板
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > tabletBreakpoint && width <= desktopBreakpoint;
  }

  /// 判断是否为移动端布局
  /// 宽度 <= 600px 视为移动端
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width <= tabletBreakpoint;
  }

  /// 获取当前屏幕宽度
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// 获取当前屏幕高度
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// 根据屏幕类型返回不同的值
  /// [mobile] 移动端值
  /// [tablet] 平板值（可选，默认使用移动端值）
  /// [desktop] 桌面端值
  static T valueByDevice<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    if (isDesktop(context)) {
      return desktop;
    } else if (isTablet(context)) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }

  /// 获取响应式的最大内容宽度
  /// 桌面端限制最大宽度，移动端不限制
  static double getMaxContentWidth(BuildContext context, {double maxWidth = 1400}) {
    return isDesktop(context) ? maxWidth : double.infinity;
  }
}
