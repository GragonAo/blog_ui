import 'package:hive/hive.dart';
import 'package:blog_ui/models/user/info.dart';
import 'package:blog_ui/utils/storage.dart';


Box setting = GStrorage.setting;
Box localCache = GStrorage.localCache;
Box userInfoCache = GStrorage.userInfo;

class GlobalDataCache {
  late int imgQuality;
  late bool enablePlayerControlAnimation;
  late List<String> actionTypeSort;

  // 用户信息
  UserInfoData? userInfo;

  // 私有构造函数
  GlobalDataCache._();

  // 单例实例
  static final GlobalDataCache _instance = GlobalDataCache._();

  // 获取全局实例
  factory GlobalDataCache() => _instance;

  // 异步初始化方法
  Future<void> initialize() async {
    imgQuality = await setting.get(SettingBoxKey.defaultPicQa,
        defaultValue: 10); // 设置全局变量
    enablePlayerControlAnimation = setting
        .get(SettingBoxKey.enablePlayerControlAnimation, defaultValue: true);
    actionTypeSort = await setting.get(SettingBoxKey.actionTypeSort,
        defaultValue: ['like', 'coin', 'collect', 'watchLater', 'share']);

    userInfo = userInfoCache.get('userInfoCache');
  }
}
