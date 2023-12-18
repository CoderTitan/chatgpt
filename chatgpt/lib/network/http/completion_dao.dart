import 'package:chatgpt/network/http/completions.dart';
import 'package:chatgpt/untils/conversation_helper.dart';
import 'package:flutter/material.dart';

class CompletionDao {
  final IConversationContext conversationHelper = ConversationHelper();
  /// 和ChatGPT对话
  Future<String?> createCompletion({required String prompt}) async {
    var fullPrompt = conversationHelper.getPromptContext(prompt);
    final response = await TKCompletion().createChat(prompt: fullPrompt, maxTokens: 1000);
    final choices = response.choices?.first;
    var content = choices?.message?.content;
    debugPrint('content = $content');

    if (content != null) {
      var list = content.split('A:'); //过滤掉不想展示的字符
      content = list.length > 1 ? list[1] : content;
      content = content.replaceFirst("\n\n", ""); //过滤掉开始的换行
      conversationHelper.add(ConversationContextModel(prompt, content));
    }
    return content;
  }
}
