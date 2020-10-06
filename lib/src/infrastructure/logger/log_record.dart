import 'package:clock/clock.dart';

import 'log_level.dart';

class LogRecord {


  LogRecord(this.level, this.message, this.loggerName, [this.stackTrace]) : time = clock.now();

  LogLevel level;
  String message;
  String loggerName;
  DateTime time;
  StackTrace stackTrace;
  
  @override
  String toString() => '$loggerName | $level | $time | $message';
}
 