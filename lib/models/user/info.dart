import 'package:hive/hive.dart';

part 'info.g.dart';

@HiveType(typeId: 4)
class UserInfoData {
  UserInfoData({
    this.isLogin,
    this.username,
    this.email,
    this.web3Info,
  });
  @HiveField(0)
  bool? isLogin;
  @HiveField(1)
  int? username;
  @HiveField(2)
  String? email;
  @HiveField(3)
  Web3Info? web3Info;

  UserInfoData.fromJson(Map<String, dynamic> json) {
    isLogin = json['isLogin'] ?? false;
    username = json['username'];
    email = json['email'];
    web3Info = json['web3_info'] != null
        ? Web3Info.fromJson(json['web3_info'])
        : Web3Info();
  }
}

@HiveType(typeId: 5)
class Web3Info {
  Web3Info({
    this.chainId,
    this.address
  });
  @HiveField(0)
  int? chainId;
  @HiveField(1)
  String? address;

  Web3Info.fromJson(Map<String, dynamic> json) {
    chainId = json['chain_id'];
    address = json['address'];
  }
}

class UserBaseInfo {
  final int id;
  final String username;
  final String? avatar;
  UserBaseInfo({
    required this.id,
    required this.username,
    this.avatar,
  });

  factory UserBaseInfo.fromJson(Map<String, dynamic> json) {
    return UserBaseInfo(
      id: json['id'] as int,
      username: json['username'] as String,
      avatar: json['avatar'] as String?,
    );
  }
}