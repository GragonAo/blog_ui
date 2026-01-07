import 'constants.dart';

class Api {
  // github 获取最新版
  static const String latestApp =
      'https://api.github.com/repos/guozhigq/pilipala/releases/latest';

  // 用户动态主页
  static const dynamicSpmPrefix = 'https://space.bilibili.com/1/dynamic';

  // 使用web3登录获取 nonce
  static const String blogLoginWeb3Nonce =
      '${HttpString.blogApiBaseUrl}/auth/web3-login/nonce';
  // 使用web3登录
  static const String blogLoginWeb3 =
      '${HttpString.blogApiBaseUrl}/auth/web3-login';
      
}