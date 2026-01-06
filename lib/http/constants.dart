class HttpString {
  // Blog 后端 API 地址 - 请根据实际情况修改
  static const String blogApiBaseUrl = 'http://192.168.40.132:8080'; // 开发环境
  // static const String blogApiBaseUrl = 'https://your-domain.com'; // 生产环境
  
  // 原有的 Bilibili API 地址（如果其他功能还需要用到）
  static const String baseUrl = 'http://192.168.40.132:8080';
  static const String apiBaseUrl = 'https://api.bilibili.com';
  static const String tUrl = 'https://api.vc.bilibili.com';
  static const String appBaseUrl = 'https://app.bilibili.com';
  static const String liveBaseUrl = 'https://api.live.bilibili.com';
  static const String passBaseUrl = 'https://passport.bilibili.com';
  static const String messageBaseUrl = 'https://message.bilibili.com';
  static const String bangumiBaseUrl = 'https://bili.meark.me';
  static const List<int> validateStatusCodes = [
    302,
    304,
    307,
    400,
    401,
    403,
    404,
    405,
    409,
    412,
    500,
    503,
    504,
    509,
    616,
    617,
    625,
    626,
    628,
    629,
    632,
    643,
    650,
    652,
    658,
    662,
    688,
    689,
    701,
    799,
    8888
  ];
}