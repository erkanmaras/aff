import 'dart:async';
import 'package:flutter/foundation.dart';
import 'log_level.dart';
import 'log_record.dart';

class Logger {
  factory Logger(
    {String name='',
    LogLevel logLevel = LogLevel.all,
    LogLevel recordStackTraceAtLevel = LogLevel.off,
  }) {
    return _loggers.putIfAbsent(name, () => Logger._(logLevel, recordStackTraceAtLevel));
  }

  Logger._(this.logLevel, this.recordStackTraceAtLevel);

  String name;
  LogLevel logLevel;
  LogLevel recordStackTraceAtLevel;

  static final Map<String, Logger> _loggers = <String, Logger>{};
  static StreamController<LogRecord> _controller;
  static Stream<LogRecord> get onLog {
    return _getStream();
  }

  void clearListeners() {
    _controller?.close();
    _controller = null;
  }

  bool isLoggable(LogLevel value) {
    return value.index >= logLevel.index;
  }

  void log(LogLevel logLevel, dynamic message, {Type callerType, StackTrace stackTrace}) {
    try {
      if (!isLoggable(logLevel)) {
        return;
      }

      if (message is Function) {
        message = message();
      }

      String msg;
      if (message is String) {
        msg = message;
      } else {
        msg = (message ?? '').toString();
      }

      if (stackTrace == null && logLevel.index >= recordStackTraceAtLevel.index) {
        stackTrace = StackTrace.current;
      }

      if (name?.isEmpty ?? true) {
        name = (callerType ?? '').toString();
      }

      var log = LogRecord(logLevel, msg, name, stackTrace);

      _publish(log);
    } catch (e) {
      if (!kReleaseMode) {
        rethrow;
      }
    }
  }

  void trace(dynamic message, {Type callerType, StackTrace stackTrace}) =>
      log(LogLevel.trace, message, callerType: callerType, stackTrace: stackTrace);

  void debug(dynamic message, {Type callerType, StackTrace stackTrace}) =>
      log(LogLevel.debug, message, callerType: callerType, stackTrace: stackTrace);

  void information(dynamic message, {Type callerType, StackTrace stackTrace}) =>
      log(LogLevel.information, message, callerType: callerType, stackTrace: stackTrace);

  void warning(dynamic message, {Type callerType, StackTrace stackTrace}) =>
      log(LogLevel.warning, message, callerType: callerType, stackTrace: stackTrace);

  void error(dynamic message, {Type callerType, StackTrace stackTrace}) =>
      log(LogLevel.error, message, callerType: callerType, stackTrace: stackTrace);

  void critical(dynamic message, {Type callerType, StackTrace stackTrace}) =>
      log(LogLevel.critical, message, callerType: callerType, stackTrace: stackTrace);

  static Stream<LogRecord> _getStream() {
    _controller ??= StreamController<LogRecord>.broadcast(sync: true);
    return _controller.stream;
  }

  void _publish(LogRecord record) {
    _controller?.add(record);
  }
}
