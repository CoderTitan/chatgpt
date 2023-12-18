import 'package:flutter/cupertino.dart';

enum OwnerType { receiver, sender }

///枚举类型在数据库保存为string，取出时转成枚举
OwnerType _of(String name) {
  if (name == OwnerType.receiver.toString()) {
    return OwnerType.receiver;
  } else {
    return OwnerType.sender;
  }
}

class MessageModel {
  final int? id;

  ///为了避免添加数据的时候重新刷新的问题
  final GlobalKey key;

  ///消息发送方和接收方的标识，用于决定消息展示在那一侧
  final OwnerType ownerType;

  ///消息发送方的名字
  final String? ownerName;

  ///头像url
  final String? avatar;

  ///消息内容
  final String content;

  ///milliseconds since
  final int createdAt;

  ///是否展示创建时间
  bool showCreatedTime = false;

  MessageModel(
      {this.id,
      this.ownerName,
      required this.ownerType,
      this.avatar,
      required this.content,
      required this.createdAt})
      : key = GlobalKey();

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
      ownerType: _of(json['ownerType']),
      content: json['content'],
      createdAt: json['createdAt'],
      ownerName: json['ownerName'],
      avatar: json['avatar'],
      id: json['id']);

  Map<String, dynamic> toJson() => {
        'id': id,
        //数据库存储不支持枚举等复合类型
        'ownerType': ownerType.toString(),
        'content': content,
        'createdAt': createdAt,
        'avatar': avatar,
        'ownerName': ownerName,
      };
}
