

import 'package:chatgpt/network/model/response.dart';

abstract class TKCreateInterface {
  Future<TKResponse> createChat(
      {String model = 'gpt-3.5-turbo',
      dynamic prompt,
      int? maxTokens = 200,
      double? temperature,
      double? topP,
      int? n,
      String? stop,
      String? user});
}
