import 'package:gate_buddy/core/errors/error_handler.dart';

mixin BaseRemoteDs {
  /// Wraps API calls with try/catch + ErrorHandler.handle()
  /// ErrorHandler.handle() throws AppException, so rethrow is not needed
  Future<T> execute<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } catch (e) {
      ErrorHandler.handle(e);
    }
  }
}
