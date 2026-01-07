import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:catcher_2/catcher_2.dart';

/// 日志服务 - 统一管理应用日志和异常捕获
class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  factory LoggerService() => _instance;
  LoggerService._internal();

  static const String _logFileName = '.pili_logs';
  late final PiliLogger _logger;

  /// 初始化日志服务
  Future<void> init() async {
    _logger = PiliLogger();
    await clearLogs();
  }

  /// 获取 Logger 实例
  PiliLogger get logger => _logger;

  /// 配置 Catcher2 异常捕获
  Future<Catcher2Options> getCatcherConfig() async {
    if (kIsWeb) {
      // Web 平台使用 SilentReportMode，不记录到文件
      return Catcher2Options(
        SilentReportMode(),
        [],
      );
    } else {
      // 原生平台记录到文件
      final logFile = await getLogsPath();
      return Catcher2Options(
        SilentReportMode(),
        logFile != null ? [FileHandler(logFile)] : [],
      );
    }
  }

  /// 获取日志文件路径
  Future<File?> getLogsPath() async {
    if (kIsWeb) {
      return null; // Web 平台不支持文件访问
    }
    String dir = (await getApplicationDocumentsDirectory()).path;
    final String filename = p.join(dir, _logFileName);
    final file = File(filename);
    if (!await file.exists()) {
      await file.create();
    }
    return file;
  }

  /// 清除日志文件
  Future<bool> clearLogs() async {
    if (kIsWeb) {
      return true; // Web 平台跳过日志清理
    }
    try {
      String dir = (await getApplicationDocumentsDirectory()).path;
      final String filename = p.join(dir, _logFileName);
      final file = File(filename);
      await file.writeAsString('');
      return true;
    } catch (e) {
      print('Error clearing logs: $e');
      return false;
    }
  }

  /// 记录错误日志
  void error(dynamic message, {Object? error, StackTrace? stackTrace}) {
    _logger.log(Level.error, message, error: error, stackTrace: stackTrace);
  }

  /// 记录警告日志
  void warning(dynamic message) {
    _logger.log(Level.warning, message);
  }

  /// 记录信息日志
  void info(dynamic message) {
    _logger.log(Level.info, message);
  }

  /// 记录调试日志
  void debug(dynamic message) {
    _logger.log(Level.debug, message);
  }

  /// 记录跟踪日志
  void trace(dynamic message) {
    _logger.log(Level.trace, message);
  }
}

// 全局快捷访问
final loggerService = LoggerService();

/// 获取 Logger 实例（保持向后兼容）
PiliLogger getLogger<T>() {
  return loggerService.logger;
}

/// 清除日志（保持向后兼容）
Future<bool> clearLogs() async {
  return await loggerService.clearLogs();
}

/// 获取日志路径（保持向后兼容）
Future<File?> getLogsPath() async {
  return await loggerService.getLogsPath();
}

/// Pili Logger 实现
class PiliLogger extends Logger {
  PiliLogger() : super();

  @override
  void log(Level level, dynamic message,
      {Object? error, StackTrace? stackTrace, DateTime? time}) async {
    if (level == Level.error && !kIsWeb) {
      // Web 平台不支持文件系统访问，跳过日志文件写入
      try {
        String dir = (await getApplicationDocumentsDirectory()).path;
        final String filename = p.join(dir, ".pili_logs");
        // 添加至文件末尾
        await File(filename).writeAsString(
          "**${DateTime.now()}** \n $message \n $stackTrace\n\n",
          mode: FileMode.writeOnlyAppend,
        );
      } catch (e) {
        print('Error writing log: $e');
      }
    }
    super.log(level, "$message", error: error, stackTrace: stackTrace);
  }
}
