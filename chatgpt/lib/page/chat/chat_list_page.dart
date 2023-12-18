import 'package:chatgpt/page/chat/chat_controller.dart';
import 'package:chatgpt/page/chat/chat_message_widget.dart';
import 'package:chatgpt/page/chat/message_model.dart';
import 'package:flutter/material.dart';

class ChatListPage extends StatefulWidget {
  final ChatController chatController;
  final OnBubbleClick? onBubbleTap;
  final OnBubbleClick? onBubbleLongPress;

  const ChatListPage({Key? key, required this.chatController, this.onBubbleTap, this.onBubbleLongPress})
      : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  ChatController get chatController => widget.chatController;

  MessageWidgetBuilder? get messageWidgetBuilder => chatController.messageWidgetBuilder;

  ScrollController get scrollController => chatController.scrollController;

  @override
  void dispose() {
    chatController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    chatController.widgetReady();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: Align(
        alignment: Alignment.topCenter,
        child: StreamBuilder<List<MessageModel>>(
          stream: chatController.messageController.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              return Scrollbar(
                controller: scrollController,
                child: ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    var message = snapshot.data![index];
                    return MessageWidget(key: message.key, message: message);
                  },
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
