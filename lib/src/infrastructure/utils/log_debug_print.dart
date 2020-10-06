import 'dart:convert';
import 'package:aff/infrastructure.dart';
import 'package:flutter/foundation.dart';

class LogDebugPrint {
  static const String lineDivider = '────────────────────────────────────────────────────────────────────────────────';
  static const String dotDivider = '┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄';
  static const _topLeftCorner = '┌';
  static const _bottomLeftCorner = '└';
  static const _middleCorner = '├';
  static const _verticalLine = '│';
  static const _topBorder = '$_topLeftCorner$lineDivider';
  static const _middleBorder = '$_middleCorner$dotDivider';
  static const _bottomBorder = '$_bottomLeftCorner$lineDivider';
  static final _stackTraceRegex = RegExp(r'#[0-9]+[\s]+(.+) \(([^\s]+)\)');
  static final _stackTraceMethodCount = 8;

  static final levelColors = {
    LogLevel.trace: _TerminalColor.fg(158),
    LogLevel.debug: _TerminalColor.fg(82),
    LogLevel.information: _TerminalColor.fg(12),
    LogLevel.warning: _TerminalColor.fg(208),
    LogLevel.error: _TerminalColor.fg(196),
    LogLevel.critical: _TerminalColor.fg(135),
  };

  static void writeLog(LogRecord event) {
    var messageStr = _stringifyMessage(event.message);
    String stackTraceStr;
    if (event.stackTrace != null) {
      stackTraceStr = _formatStackTrace(event.stackTrace, _stackTraceMethodCount);
    }
    _formatAndPrint(event.level, event.loggerName, messageStr, event.time, stackTrace: stackTraceStr);
  }

  static void writeError(AppErrorReport error) {
    var messageStr = _stringifyMessage(error.error);

    String stackTraceStr;
    if (error.stackTrace != null) {
      stackTraceStr = _formatStackTrace(error.stackTrace, _stackTraceMethodCount);
    }

    _formatAndPrint(LogLevel.error, 'AppError', messageStr, error.dateTime,
        stackTrace: stackTraceStr, context: error.context?.toString());
  }

  static String _formatStackTrace(StackTrace stackTrace, int methodCount) {
    var lines = stackTrace.toString().split('\n');

    var formatted = <String>[];
    var count = 0;
    for (var line in lines) {
      var match = _stackTraceRegex.matchAsPrefix(line);
      if (match != null) {
        var newLine = '#$count   ${(match.group(1)).trim()} (${(match.group(2)).trim()})';
        formatted.add(newLine.replaceAll('<anonymous closure>', '()'));
        if (++count == methodCount) {
          break;
        }
      } else {
        formatted.add(line);
      }
    }

    if (formatted.isNullOrEmpty()) {
      return null;
    } else {
      return formatted.join('\n');
    }
  }

  static String _stringifyMessage(dynamic message) {
    if (message is Map || message is Iterable) {
      var encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(message);
    } else {
      return message.toString();
    }
  }

  static _TerminalColor _getLevelColor(LogLevel level) {
    return levelColors[level];
  }

  static void _formatAndPrint(
    LogLevel level,
    String logggerName,
    String message,
    DateTime time, {
    String stackTrace,
    String context,
  }) {
    var color = _getLevelColor(level);
    debugPrint(color(_topBorder));

    if (!stackTrace.isNullOrWhiteSpace()) {
      for (var line in stackTrace.split('\n')) {
        debugPrint('$color$_verticalLine $line');
      }
      debugPrint(color(_middleBorder));
    }

    if (!context.isNullOrWhiteSpace()) {
      for (var line in context.split('\n')) {
        debugPrint('$color$_verticalLine $line');
      }
      debugPrint(color(_middleBorder));
    }

    if (time != null) {
      debugPrint(color('$_verticalLine ${ValueFormat.dateTimeToString(time)}'));
      debugPrint(color(_middleBorder));
    }

    for (var line in message.split('\n')) {
      debugPrint(color('$_verticalLine $line'));
    }
    debugPrint(color(_bottomBorder));
  }
}

class _TerminalColor {
  // ignore: unused_element
  _TerminalColor.none()
      : fg = null,
        bg = null,
        color = false;

  _TerminalColor.fg(this.fg)
      : bg = null,
        color = true;

  _TerminalColor.bg(this.bg)
      : fg = null,
        color = true;

  /// ANSI Control Sequence Introducer, signals the terminal for new settings.
  static const ansiEsc = '\x1B[';

  /// Reset all colors and options for current SGRs to terminal defaults.
  static const ansiDefault = '${ansiEsc}0m';

  final int fg;
  final int bg;
  final bool color;

  @override
  String toString() {
    if (fg != null) {
      return '${ansiEsc}38;5;${fg}m';
    } else if (bg != null) {
      return '${ansiEsc}48;5;${bg}m';
    } else {
      return '';
    }
  }

  String call(String msg) {
    if (color) {
      return '${this}$msg$ansiDefault';
    } else {
      return msg;
    }
  }

  _TerminalColor toFg() => _TerminalColor.fg(bg);

  _TerminalColor toBg() => _TerminalColor.bg(fg);

  /// Defaults the terminal's foreground color without altering the background.
  String get resetForeground => color ? '${ansiEsc}39m' : '';

  /// Defaults the terminal's background color without altering the foreground.
  String get resetBackground => color ? '${ansiEsc}49m' : '';

  // static int grey(double level) => 232 + (level.clamp(0.0, 1.0) * 23).round();
}
