import 'package:chatgpt/page/chat/chat_controller.dart';
import 'package:chatgpt/page/chat/chat_list_page.dart';
import 'package:chatgpt/page/chat/chat_send_widget.dart';
import 'package:chatgpt/page/chat/message_model.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String title;
  const ChatPage({Key? key, required this.title}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatController chatController;
  // late CompletionDao completionDao;
  final ScrollController _scrollController = ScrollController();
  String _inputMessage = '';

  final List<MessageModel> _messageList = [
    MessageModel(ownerType: OwnerType.receiver, content: 'ajsdnaksjndaksjndak', createdAt: 16509023902),
    MessageModel(ownerType: OwnerType.receiver, content: '卡少年的你大健康是的呢', createdAt: 16509023902),
    MessageModel(ownerType: OwnerType.receiver, content: '啊可视角度拿手机啊可视角度拿手机啊可视角度拿手机啊可视角度拿手机', createdAt: 16509023902),
    MessageModel(
        ownerType: OwnerType.sender,
        content: '阿克苏低年级扩散登记卡收纳打卡机三大金卡纳手机卡到哪萨卡手机打那实际扩大年纪啊斯卡纳打卡上加拿大撒',
        createdAt: 16509023902),
  ];

  @override
  void initState() {
    super.initState();

    chatController =
        ChatController(initialMessageList: _messageList, scrollController: _scrollController, timePellet: 60);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(child: ChatListPage(chatController: chatController)),
          ChatSendWidget(
            '请输入',
            enable: true,
            onChanged: (text) => _inputMessage = text,
            onSend: () => _onSendAction(_inputMessage),
          )
        ],
      ),
    );
  }

  void _onSendAction(String inputMessage) {
    final model = MessageModel(
      avatar: 'https://gavatar.gateimg.com/groupchat/avatar-80dd5d588d-97e203976c-3a8241-d3d944',
      ownerType: OwnerType.sender,
      content: inputMessage,
      createdAt: 16509023902,
    );
    chatController.addMessage(model);
  }
}
