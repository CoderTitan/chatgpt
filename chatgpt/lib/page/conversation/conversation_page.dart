import 'package:chatgpt/model/conversation_model.dart';
import 'package:chatgpt/network/http/completion_dao.dart';
import 'package:chatgpt/network/http/logger.dart';
import 'package:chatgpt/page/chat/chat_controller.dart';
import 'package:chatgpt/page/chat/chat_list_page.dart';
import 'package:chatgpt/page/chat/chat_send_widget.dart';
import 'package:chatgpt/page/chat/message_model.dart';
import 'package:chatgpt/storage/db_manager.dart';
import 'package:chatgpt/storage/message_dao.dart';
import 'package:flutter/material.dart';

/// 会话更新回调
typedef OnConversationUpdate = void Function(ConversationModel conversationModel);

class ConVersationPage extends StatefulWidget {
  final ConversationModel conversationModel;
  final OnConversationUpdate? conversationUpdate;

  const ConVersationPage({Key? key, required this.conversationModel, this.conversationUpdate}) : super(key: key);

  @override
  State<ConVersationPage> createState() => _ConVersationPageState();
}

class _ConVersationPageState extends State<ConVersationPage> {
  ///若为新建的对话框，则_pendingUpdate为true
  bool get _pendingUpdate => widget.conversationModel.title == null;

  ///是否有通知聊天列表页更新当前会话
  bool _hadUpdate = false;

  /// 发送消息内容
  String _inputMessage = '';

  /// 发送按钮状态
  bool _sendEnable = true;

  /// 页码
  int _pageIndex = 1;

  /// 工具类
  late ChatController chatController;
  late MessageDao messageDao;
  late CompletionDao completionDao;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _initDatas();
  }

  @override
  void dispose() {
    _updateConversation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_sendEnable ? 'ChatGPT' : 'ChatGPT正在输入...'),
      ),
      body: Column(
        children: [
          Expanded(child: ChatListPage(chatController: chatController)),
          ChatSendWidget(
            '请输入',
            enable: _sendEnable,
            onChanged: (text) => _inputMessage = text,
            onSend: () => _onSendAction(_inputMessage),
          )
        ],
      ),
    );
  }

  void _initDatas() async {
    chatController = ChatController(initialMessageList: [], scrollController: _scrollController, timePellet: 60);
    final dbManager = await DBManager.instance(dbName: DBManager.getAccountHash());
    messageDao = MessageDao(dbManager, cid: widget.conversationModel.cid);
    completionDao = CompletionDao();
    
    // 增加下拉更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMessageList(loadMore: true);
      }
    });

    // 加载第一页数据
    final list = await _loadMessageList();
    chatController.loadMoreMessage(list);
  }

  void _onSendAction(final String message) {
    widget.conversationModel.hadChanged = true;

    /// 发送信息
    _addMessage(_createModel(OwnerType.sender, message));
    setState(() {
      _sendEnable = false;
    });

    _onReceiver();
  }

  void _onReceiver() async {
    /// 获取接收到的信息
    String? response = '';
    try {
      response = await completionDao.createCompletion(prompt: _inputMessage);
      response = response?.replaceFirst('\n\n', '');
    } catch (e) {
      response = e.toString();
      debugPrint(response);
    }

    _addMessage(_createModel(OwnerType.receiver, response ?? ''));
    setState(() {
      _sendEnable = true;
    });
  }

  ///通知聊天列表页更新当前会话
  _notifyConversationListUpdate() {
    if (!_hadUpdate && _pendingUpdate && widget.conversationUpdate != null) {
      _hadUpdate = true;
      _updateConversation();
      widget.conversationUpdate!(widget.conversationModel);
    }
  }

  void _updateConversation() {
    //更新会话信息
    if (chatController.initialMessageList.isNotEmpty) {
      var model = chatController.initialMessageList.first;
      widget.conversationModel.lastMessage = model.content;
      widget.conversationModel.updateAt = model.createdAt;
      widget.conversationModel.title ??= chatController.initialMessageList.last.content ?? "";
    }
  }

  void _addMessage(MessageModel model) {
    chatController.addMessage(model);
    messageDao.saveMessage(model);
    _notifyConversationListUpdate();
  }

  MessageModel _createModel(OwnerType type, String message) {
    String ownerName, avatar;
    if (type == OwnerType.receiver) {
      ownerName = 'ChatGPT';
      avatar = 'https://o.devio.org/images/o_as/avatar/tx4.jpeg';
    } else {
      ownerName = 'Titan';
      avatar = 'https://o.devio.org/images/o_as/avatar/tx1.jpeg';
    }
    return MessageModel(
      ownerName: ownerName,
      avatar: avatar,
      ownerType: type,
      content: message,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<List<MessageModel>> _loadMessageList({bool loadMore = false}) async {
    if (loadMore) {
      _pageIndex++;
    } else {
      _pageIndex = 1;
    }
    final list = await messageDao.getMessages(pageIndex: _pageIndex, pageSize: 20);
    Logger.log('count:${list.length}');
    if (loadMore) {
      if (list.isNotEmpty) {
        chatController.loadMoreMessage(list);
      } else {
        //如果没有更多的数据，则pageIndex不增加
        _pageIndex--;
      }
    }
    return list;
  }
}
