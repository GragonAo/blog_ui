import 'package:flutter/foundation.dart';

/// 平台检测工具类
class PlatformHelper {
  /// 是否为 Android 平台
  static bool get isAndroid => !kIsWeb && _isAndroidNative;
  
  /// 是否为 iOS 平台
  static bool get isIOS => !kIsWeb && _isIOSNative;
  
  /// 是否为桌面平台
  static bool get isDesktop => !kIsWeb && (_isWindowsNative || _isMacOSNative || _isLinuxNative);
  
  // 内部实现
  static bool get _isAndroidNative {
    try {
      return defaultTargetPlatform == TargetPlatform.android;
    } catch (e) {
      return false;
    }
  }
  
  static bool get _isIOSNative {
    try {
      return defaultTargetPlatform == TargetPlatform.iOS;
    } catch (e) {
      return false;
    }
  }
  
  static bool get _isWindowsNative {
    try {
      return defaultTargetPlatform == TargetPlatform.windows;
    } catch (e) {
      return false;
    }
  }
  
  static bool get _isMacOSNative {
    try {
      return defaultTargetPlatform == TargetPlatform.macOS;
    } catch (e) {
      return false;
    }
  }
  
  static bool get _isLinuxNative {
    try {
      return defaultTargetPlatform == TargetPlatform.linux;
    } catch (e) {
      return false;
    }
  }
}
