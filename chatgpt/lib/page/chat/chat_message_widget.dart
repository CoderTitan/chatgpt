import 'package:bubble/bubble.dart';
import 'package:chatgpt/page/chat/message_model.dart';
import 'package:flutter/material.dart';

typedef MessageWidgetBuilder = Widget Function(MessageModel message);
typedef OnBubbleClick = void Function(MessageModel message, BuildContext ancestor);

class MessageWidget extends StatelessWidget {
  final MessageModel message;
  final MessageWidgetBuilder? messageWidget;

  final double avatarSize;

  const MessageWidget({required GlobalKey key, required this.message, this.messageWidget, this.avatarSize = 40})
      : super(key: key);

  String get senderInitials {
    if (message.ownerName == null) return "";
    List<String> chars = message.ownerName!.split(" ");
    if (chars.length > 1) {
      return chars[0];
    } else {
      return message.ownerName![0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
          child: _buildContent(context),
        )
      ],
    );
  }

  Widget _buildCircleAvatar() {
    final avatar = message.avatar ?? '';
    return avatar.isNotEmpty
        ? ClipOval(
            child: Image.network(
              message.avatar!,
              height: avatarSize,
              width: avatarSize,
            ),
          )
        : CircleAvatar(
            radius: 20,
            child: Text(
              senderInitials,
              style: const TextStyle(fontSize: 16),
            ));
  }

  Widget _buildContent(BuildContext context) {
    return message.ownerType == OwnerType.receiver ? _buildReceiver(context) : _buildSender(context);
  }

  Widget _buildReceiver(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 48),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCircleAvatar(),
          const SizedBox(width: 8),
          Flexible(
              child: Bubble(
            showNip: true,
            stick: true,
            nip: BubbleNip.leftTop,
            alignment: Alignment.topLeft,
            color: Colors.white,
            child: _buildContentText(TextAlign.left, context),
          ))
        ],
      ),
    );
  }

  Widget _buildSender(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 48),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
              child: Bubble(
            showNip: true,
            stick: true,
            nip: BubbleNip.rightTop,
            alignment: Alignment.topRight,
            color: Colors.blue.shade200,
            child: _buildContentText(TextAlign.left, context),
          )),
          const SizedBox(width: 8),
          _buildCircleAvatar(),
        ],
      ),
    );
  }

  Widget _buildContentText(TextAlign align, BuildContext context) {
    return InkWell(
      onTap: () {},
      onLongPress: () {},
      child: Text(
        message.content,
        textAlign: align,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
