import 'dart:async';

import 'package:chatgpt/page/chat/chat_message_widget.dart';
import 'package:chatgpt/page/chat/message_model.dart';
import 'package:flutter/material.dart';

class ChatController implements IChatController {

  StreamController<List<MessageModel>> messageController = StreamController();
  
  ///初始化数据
  final List<MessageModel> initialMessageList;
  final ScrollController scrollController;

  ///Provide MessageWidgetBuilder to customize your bubble style.
  final MessageWidgetBuilder? messageWidgetBuilder;

  ///展示时间的间隔，单位秒
  final int timePellet;
  List<int> pelletShow = [];


  ChatController({required this.initialMessageList,
    required this.scrollController,
    required this.timePellet,
    this.messageWidgetBuilder}) {
    for (var message in initialMessageList.reversed) {
      inflateMessage(message);
    }
  }

  @override
  void addMessage(MessageModel message) {
    //fix Bad state: Cannot add event after closing
    if (!scrollController.hasClients) { return; }
    inflateMessage(message);
    //List反转后列是从底部向上展示，所以新来的消息需要插入到数据第0个位置
    initialMessageList.insert(0, message);
    messageController.sink.add(initialMessageList);
    scrollToLastMessage();
  }

  @override
  void deleteMessage(MessageModel message) {
    if (!scrollController.hasClients) { return; }
    initialMessageList.remove(message);
    pelletShow.clear();
    for (var element in initialMessageList) {
      inflateMessage(element);
    }
    messageController.sink.add(initialMessageList);
  }

  @override
  void loadMoreMessage(List<MessageModel> messages) {
    final messageList = List.from(messages.reversed);
    List<MessageModel> tempList = [...initialMessageList, ...messageList];
    pelletShow.clear();
    for (var element in tempList) {
      inflateMessage(element);
    }
    initialMessageList.clear();
    initialMessageList.addAll(tempList);
    if (!scrollController.hasClients) { return; }
    messageController.sink.add(initialMessageList);
  }

  /// 销毁
  void dispose() {
    messageController.close();
    scrollController.dispose();
  }

  /// 列表加载完成
  void widgetReady() {
    if (!messageController.isClosed) {
      messageController.sink.add(initialMessageList);
    }
    if (initialMessageList.isNotEmpty) {
      scrollToLastMessage();
    }
  }

  /// 滚动到最底部
  void scrollToLastMessage() {
    if (!scrollController.hasClients) { return; }
    scrollController.animateTo(0, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  ///设置消息的时间是否可以展示
  void inflateMessage(MessageModel message) {
    int pellet = (message.createdAt / (timePellet * 1000)).truncate();
    if (!pelletShow.contains(pellet)) {
      pelletShow.add(pellet);
      message.showCreatedTime = true;
    } else {
      message.showCreatedTime = false;
    }
  }
}


abstract class IChatController {
  /// 添加消息
  void addMessage(MessageModel message);
  
  /// 删除消息
  void deleteMessage(MessageModel message);

  /// 加载更多消息
  void loadMoreMessage(List<MessageModel> messages);
}