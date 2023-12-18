import 'package:flutter/material.dart';

///聊天输入框
class ChatSendWidget extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSend;
  final String hint;
  final bool enable;

  const ChatSendWidget(this.hint, {Key? key, this.onChanged, this.onSend, this.enable = true}) : super(key: key);

  @override
  State<ChatSendWidget> createState() => _ChatSendWidgetState();
}

class _ChatSendWidgetState extends State<ChatSendWidget> {
  bool _showSend = false;
  final _controller = TextEditingController();

  get _sendBtn => (color) => Container(
        margin: const EdgeInsets.only(left: 10),
        width: 65,
        child: MaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          height: 35,
          disabledColor: color.withOpacity(0.6),
          color: color,
          onPressed: widget.enable ? _onSend : null,
          child: const Text(
            '发送',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );

  get _input => Expanded(
          child: TextField(
        onChanged: _onChanged,
        controller: _controller,
        //回车发送消息
        onSubmitted: (_) {
          _onSend();
        },
        style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400),
        //输入框的样式
        decoration: InputDecoration(
          border: OutlineInputBorder(
            //设置填充圆角
            borderRadius: BorderRadius.circular(6),
            //取消边框
            borderSide: const BorderSide(width: 0, style: BorderStyle.none),
          ),
          filled: true,
          //输入框样式的大小约束
          constraints: const BoxConstraints(maxHeight: 39),
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.only(left: 10),
          hintStyle: const TextStyle(fontSize: 16),
          hintText: widget.hint,
        ),
      ));

  @override
  Widget build(BuildContext context) {
    var bottom = MediaQuery.of(context).padding.bottom;
    if (bottom == 0.0) {
      //适配iOS刘海屏以外的设备
      bottom = 20;
    }
    return Container(
      height: 50 + bottom,
      padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: bottom),
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2)),
      child: Row(
        children: [_input, if (_showSend) _sendBtn(Colors.blue)],
      ),
    );
  }

  void _onChanged(String value) {
    if (widget.onChanged != null) widget.onChanged!(value);
    setState(() {
      _showSend = value.isNotEmpty;
    });
  }

  void _onSend() {
    if (widget.onSend != null) {
      widget.onSend!();
      _controller.clear();
      setState(() {
        _showSend = false;
      });
    }
  }
}
