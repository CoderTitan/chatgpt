import 'dart:convert';
import 'dart:io';

import 'package:chatgpt/network/http/config.dart';
import 'package:chatgpt/network/http/exception.dart';
import 'package:chatgpt/network/http/logger.dart';
import 'package:http/io_client.dart';

class TKRequest {
  static Future<T> post<T>(String url,
      {required T Function(Map<String, dynamic>) onSuccess, Map<String, dynamic>? htttpBody}) async {
    // 借助HttpClient来发送请求
    final httpClient = HttpClient();

    // 设置代理
    final proxyKey = TKConfigBuilder.instance.proxyKey;
    if (proxyKey != null && proxyKey.trim().isNotEmpty) {
      httpClient.findProxy = (url) => 'PROXY $proxyKey';
    }

    final myClient = IOClient(httpClient);
    final response = await myClient.post(Uri.parse(url),
        headers: TKConfigBuilder.instance.headers(), body: htttpBody == null ? null : jsonEncode(htttpBody));

    // 防止乱码
    Utf8Decoder utf8Decoder = const Utf8Decoder();
    final decodedBody = jsonDecode(utf8Decoder.convert(response.bodyBytes));
    if (decodedBody is Map) {
      Map<String, dynamic> data = decodedBody as Map<String, dynamic>;
      if (data['error'] != null) {
        Logger.log("an error occurred, throwing exception");
        final Map<String, dynamic> error = decodedBody['error'];
        throw TKRequestException(error['message'], response.statusCode);
      } else {
        Logger.log("request finished successfully");
        return onSuccess(decodedBody);
      }
    } else {
      throw TKRequestException('解析失败', response.statusCode);
    }
  }
}
