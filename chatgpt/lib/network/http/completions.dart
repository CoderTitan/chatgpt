import 'package:chatgpt/network/http/config.dart';
import 'package:chatgpt/network/http/create_interface.dart';
import 'package:chatgpt/network/http/http_request.dart';
import 'package:chatgpt/network/model/response.dart';

class TKCompletion implements TKCreateInterface {
  /// 创建一个新的会话并返回一个 [AIResponse] 对象。
  /// 给定一个prompt（提示），模型将返回一个或多个completions（我们可以将其理解为结论，下面统称结论）。
  /// [model] 是用于会话的模型的 ID。
  /// 你可以使用 https://api.openai.com/v1/models 接口来获取可用模型的列表，或者访问 Models Overview https://platform.openai.com/docs/models/overview页面。
  ///
  /// [prompt] 是要生成结论的提示，支持[String]和[List<String>] 类型。
  ///
  /// [maxTokens] 生成结论能够使用的最大Token数，数值越大返回的内容越长，但生成速度也就越慢。
  ///
  /// [temperature] 用来控制生成结论的随机性，介于 0 和 2 之间。数值越高越随机（如 0.8），数值越低约不随机（如 0.2），如果你想让结论更集中和确定性可以将数值调小。
  ///
  /// [topP] 是与temperature采样相对应的另一种方法，称为核心采样，模型会考虑具有前 top_p 概率质量的令牌的结果。因此，0.1 表示仅考虑组成前 10% 概率质量的令牌。
  ///
  /// [n] 定义每个提示要生成的结论数量。
  ///
  /// [stop] 可以理解为结束标识符，是一个包含最多 4 个序列的列表，API 将停止生成进一步的token。返回的文本将不包含停止序列。
  ///
  /// [user] 一个表示你最终用户的唯一标识符，可以帮助OpenAI监控和检测滥用行为。
  @override
  Future<TKResponse> createChat(
      {String model = 'gpt-3.5-turbo',
      prompt,
      int? maxTokens = 200,
      double? temperature,
      double? topP,
      int? n,
      String? stop,
      String? user}) async {
    //通过断言来检查参数的合法性，是封装SDK常用的工具
    assert(prompt is String, 'prompt field must be a String');

    return await TKRequest.post(TKConfigBuilder.instance.chatUrl, onSuccess: (Map<String, dynamic> response) {
      return TKResponse.fromJson(response);
    }, htttpBody: {
      'model': model,
      if (prompt != null)
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
      if (maxTokens != null) 'max_tokens': maxTokens,
      if (temperature != null) 'temperature': temperature,
      if (topP != null) 'top_p': topP,
      if (n != null) 'n': n,
      if (stop != null) 'stop': stop,
      if (user != null) 'user': user
    });
  }
}
