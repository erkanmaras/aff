import 'dart:async';
import 'dart:isolate';
import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';

typedef Future<void> AppMain();

class AppErrorHandler {
  AppErrorHandler();

  static void Function(AppErrorReport error) onShow;
  static void Function(AppErrorReport error) onReport;

  static Future<void> track(AppMain appMain) async {
    FlutterError.onError = (details) async {
      //consola göndermek gereklimi ?
      // if (!kReleaseMode) {
      //   FlutterError.dumpErrorToConsole(details);
      // }
      await _handle(details.exception, details.stack, context: details.context);
    };

    Isolate.current.addErrorListener(RawReceivePort((List<dynamic> isolateError) async {
      await _handle(isolateError.first, isolateError.last as StackTrace);
    }).sendPort);

    await runZonedGuarded(appMain, (Object error, StackTrace stackTrace) async {
      await _handle(error, stackTrace);
    });
  }

  static Future<void> _handle(dynamic error, StackTrace stackTrace, {DiagnosticsNode context}) async {
    if (!kReleaseMode) {
      debugPrint('AppErrorHandler handle: $error');
    }
    var appErrorReport = AppErrorReport(error, stackTrace, clock.now(), context: context);

    try {
      if (onReport != null) {
        onReport(appErrorReport);
      }
    } catch (e) {
      if (!kReleaseMode) {
        rethrow;
      } else {
        //can we do anything ???
      }
    }

    try {
      if (onShow != null) {
        onShow(appErrorReport);
      }
    } catch (e) {
      if (!kReleaseMode) {
        rethrow;
      } else {
        //can we do anything ???
      }
    }
  }

  static Future<AppErrorReport> _createAppError(dynamic exceptionORerror) async {
    StackTrace stackTrace;

    if (exceptionORerror is Error) {
      stackTrace = exceptionORerror.stackTrace;
    }

    return AppErrorReport(
      exceptionORerror,
      stackTrace,
      clock.now(),
    );
  }

  static Future<void> show(dynamic exceptionORerror) async {
    if (onShow == null) {
      throw Exception('onShow method is null !');
    }

    onShow(await _createAppError(exceptionORerror));
  }

  static Future<void> report(dynamic exceptionORerror) async {
    if (onReport == null) {
      throw Exception('onShow method is null !');
    }
    onReport(await _createAppError(exceptionORerror));
  }
}

class AppErrorReport {
  AppErrorReport(
    this.error,
    this.stackTrace,
    this.dateTime, {
    this.context,
  });

  final dynamic error;
  final StackTrace stackTrace;
  final DateTime dateTime;

  //if error is Flutter error this property contains FlutterErrorDetails.context
  //else contains null for now
  final DiagnosticsNode context;
}
