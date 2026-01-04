// final _loggerFactory =

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

final _loggerFactory = PiliLogger();

PiliLogger getLogger<T>() {
  return _loggerFactory;
}

class PiliLogger extends Logger {
  PiliLogger() : super();

  @override
  void log(Level level, dynamic message,
      {Object? error, StackTrace? stackTrace, DateTime? time}) async {
    if (level == Level.error && !kIsWeb) {
      // Web 平台不支持文件系统访问，跳过日志文件写入
      String dir = (await getApplicationDocumentsDirectory()).path;
      // 创建logo文件
      final String filename = p.join(dir, ".pili_logs");
      // 添加至文件末尾
      await File(filename).writeAsString(
        "**${DateTime.now()}** \n $message \n $stackTrace",
        mode: FileMode.writeOnlyAppend,
      );
    }
    super.log(level, "$message", error: error, stackTrace: stackTrace);
  }
}

Future<File?> getLogsPath() async {
  if (kIsWeb) {
    return null; // Web 平台不支持文件访问
  }
  String dir = (await getApplicationDocumentsDirectory()).path;
  final String filename = p.join(dir, ".pili_logs");
  final file = File(filename);
  if (!await file.exists()) {
    await file.create();
  }
  return file;
}

Future<bool> clearLogs() async {
  if (kIsWeb) {
    return true; // Web 平台跳过日志清理
  }
  String dir = (await getApplicationDocumentsDirectory()).path;
  final String filename = p.join(dir, ".pili_logs");
  final file = File(filename);
  try {
    await file.writeAsString('');
  } catch (e) {
    print('Error clearing file: $e');
    return false;
  }
  return true;
}
