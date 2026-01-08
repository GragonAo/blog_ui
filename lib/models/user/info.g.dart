// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserInfoDataAdapter extends TypeAdapter<UserInfoData> {
  @override
  final int typeId = 4;

  @override
  UserInfoData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserInfoData(
      isLogin: fields[0] as bool?,
      username: fields[1] as int?,
      email: fields[2] as String?,
      web3Info: fields[3] as Web3Info?,
    );
  }

  @override
  void write(BinaryWriter writer, UserInfoData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.isLogin)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.web3Info);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInfoDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class Web3InfoAdapter extends TypeAdapter<Web3Info> {
  @override
  final int typeId = 5;

  @override
  Web3Info read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Web3Info(
      chainId: fields[0] as int?,
      address: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Web3Info obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.chainId)
      ..writeByte(1)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Web3InfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
