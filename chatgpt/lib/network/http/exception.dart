/// 抛出的异常
class TKException implements Exception {
  final String message;

  TKException(this.message);

  @override
  String toString() {
    return message;
  }
}

class TKRequestException implements Exception {
  final String message;
  final int statusCode;

  TKRequestException(this.message, this.statusCode);

  @override
  String toString() {
    return 'RequestFailedException{message: $message, statusCode: $statusCode}';
  }
}
